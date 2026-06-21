import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../../features/ai/application/melange_providers.dart';
import '../../../shared/presentation/vaani_shell.dart';

class OcrScreen extends ConsumerStatefulWidget {
  const OcrScreen({super.key, this.cameraEnabled = true});

  final bool cameraEnabled;

  @override
  ConsumerState<OcrScreen> createState() => _OcrScreenState();
}

class _OcrScreenState extends ConsumerState<OcrScreen>
    with WidgetsBindingObserver {
  CameraController? _cameraController;
  var _cameraState = _ScannerCameraState.loading;
  var _scanning = false;
  var _flashOn = false;
  var _queuedItemCount = 0;
  final _invoiceItems = _defaultInvoiceItems
      .map((item) => item.copyWith(selected: true))
      .toList(growable: true);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (widget.cameraEnabled) {
      _initializeCamera();
    } else {
      _cameraState = _ScannerCameraState.mock;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _disposeCamera(updateState: false);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!widget.cameraEnabled) return;
    if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    } else if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.detached) {
      _disposeCamera(updateState: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedCount = _invoiceItems.where((item) => item.selected).length;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const VaaniAppHeader(
                  subtitle: 'Invoice Scanner',
                  showSearch: false,
                ),
                Expanded(
                  child: _ScannerPreview(
                    controller: _cameraController,
                    state: _cameraState,
                    scanning: _scanning,
                    flashOn: _flashOn,
                    onScan: _simulateScan,
                    onToggleFlash: _toggleFlash,
                    onRetryCamera: _initializeCamera,
                  ),
                ),
              ],
            ),
            DraggableScrollableSheet(
              initialChildSize: 0.43,
              minChildSize: 0.32,
              maxChildSize: 0.82,
              builder: (context, controller) {
                final scheme = Theme.of(context).colorScheme;
                return Container(
                  decoration: BoxDecoration(
                    color: scheme.surface,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                  child: ListView(
                    controller: controller,
                    padding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
                    children: [
                      Center(
                        child: Container(
                          width: 58,
                          height: 6,
                          decoration: BoxDecoration(
                            color: scheme.outlineVariant,
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Review Invoice',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Chip(
                            label: Text(_scanning ? 'Scanning' : 'AI Review'),
                            avatar: Icon(
                              _scanning ? Icons.radar_rounded : Icons.bolt,
                              size: 18,
                            ),
                            backgroundColor: VaaniTheme.primary,
                            labelStyle: TextStyle(color: scheme.onPrimary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _queuedItemCount > 0
                            ? '$_queuedItemCount items are ready in the inventory queue.'
                            : 'Confirm extracted items before they touch inventory.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: _queuedItemCount > 0
                                  ? VaaniTheme.secondary
                                  : VaaniTheme.onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: 6),
                      FutureBuilder<Map<String, Object?>>(
                        future: ref.watch(melangeModelsProvider.future),
                        builder: (context, snapshot) {
                          final data = snapshot.data ?? const {};
                          final invoiceModel =
                              data['invoiceModel'] as String? ?? 'unknown';
                          final asrEncoderModel =
                              data['asrEncoderModel'] as String? ?? 'unknown';
                          final asrDecoderModel =
                              data['asrDecoderModel'] as String? ?? 'unknown';
                          return Text(
                            'Melange invoice model: $invoiceModel | Whisper encoder: $asrEncoderModel | Whisper decoder: $asrDecoderModel',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: VaaniTheme.onSurfaceVariant,
                                    ),
                          );
                        },
                      ),
                      const SizedBox(height: 18),
                      for (final item in _invoiceItems) ...[
                        _InvoiceItem(
                          item: item,
                          onChanged: (value) {
                            setState(() => item.selected = value);
                          },
                        ),
                        const SizedBox(height: 12),
                      ],
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _simulateScan,
                              icon: const Icon(Icons.refresh_rounded),
                              label: const Text('Scan again'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: selectedCount == 0
                                  ? null
                                  : () => _queueSelectedItems(selectedCount),
                              icon: Icon(
                                _queuedItemCount > 0
                                    ? Icons.check_circle_outline
                                    : Icons.add_business_outlined,
                              ),
                              label: Text(
                                _queuedItemCount > 0 ? 'Queued' : 'Add items',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _initializeCamera() async {
    setState(() => _cameraState = _ScannerCameraState.loading);
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        if (mounted) setState(() => _cameraState = _ScannerCameraState.empty);
        return;
      }

      final controller = CameraController(
        cameras.first,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await _disposeCamera(updateState: false);
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() {
        _cameraController = controller;
        _cameraState = _ScannerCameraState.ready;
      });
    } on MissingPluginException {
      if (mounted) setState(() => _cameraState = _ScannerCameraState.mock);
    } on CameraException {
      if (mounted) setState(() => _cameraState = _ScannerCameraState.mock);
    } catch (_) {
      if (mounted) setState(() => _cameraState = _ScannerCameraState.mock);
    }
  }

  Future<void> _disposeCamera({required bool updateState}) async {
    final controller = _cameraController;
    _cameraController = null;
    if (updateState && mounted) {
      setState(() {
        _cameraState = widget.cameraEnabled
            ? _ScannerCameraState.loading
            : _ScannerCameraState.mock;
      });
    }
    if (controller != null) {
      try {
        await controller.dispose();
      } catch (_) {}
    }
  }

  Future<void> _toggleFlash() async {
    final controller = _cameraController;
    setState(() => _flashOn = !_flashOn);
    if (controller == null || !controller.value.isInitialized) {
      showVaaniSnackBar(context, _flashOn ? 'Flash on' : 'Flash off');
      return;
    }
    try {
      await controller.setFlashMode(_flashOn ? FlashMode.torch : FlashMode.off);
    } on CameraException {
      if (mounted) showVaaniSnackBar(context, 'Flash is unavailable');
    }
  }

  Future<void> _simulateScan() async {
    if (_scanning) return;
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _scanning = true);
    await Future<void>.delayed(const Duration(milliseconds: 650));
    if (!mounted) return;
    try {
      final parsed = await ref.read(melangeAiClientProvider).extractInvoice(
            ocrText: _sampleInvoiceText,
            locale: 'en-IN',
          );
      final nextItems = <_InvoiceItemUi>[];
      final items = parsed['items'];
      if (items is List) {
        for (final item in items) {
          if (item is Map) {
            nextItems.add(
              _InvoiceItemUi(
                icon: Icons.shopping_bag_outlined,
                name: '${item['name'] ?? 'Item'}',
                qty:
                    'Qty: ${item['quantity'] ?? '?'} ${item['unit'] ?? 'units'}',
                amount: _formatAmount(item['price']),
              ),
            );
          }
        }
      }

      setState(() {
        _scanning = false;
        _invoiceItems
          ..clear()
          ..addAll(
            (nextItems.isEmpty ? _defaultInvoiceItems : nextItems)
                .map((item) => item.copyWith(selected: true)),
          );
      });
      messenger.showSnackBar(
        const SnackBar(content: Text('Invoice parsed on-device')),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _scanning = false;
        _invoiceItems
          ..clear()
          ..addAll(
            _defaultInvoiceItems.map((item) => item.copyWith(selected: true)),
          );
      });
      messenger.showSnackBar(
        const SnackBar(content: Text('Invoice scan refreshed')),
      );
    }
  }

  void _queueSelectedItems(int selectedCount) {
    setState(() => _queuedItemCount = selectedCount);
    showVaaniSnackBar(context, '$selectedCount items queued for inventory');
  }
}

class _ScannerPreview extends StatelessWidget {
  const _ScannerPreview({
    required this.controller,
    required this.state,
    required this.scanning,
    required this.flashOn,
    required this.onScan,
    required this.onToggleFlash,
    required this.onRetryCamera,
  });

  final CameraController? controller;
  final _ScannerCameraState state;
  final bool scanning;
  final bool flashOn;
  final VoidCallback onScan;
  final VoidCallback onToggleFlash;
  final VoidCallback onRetryCamera;

  @override
  Widget build(BuildContext context) {
    final readyController = controller;
    final showCamera = state == _ScannerCameraState.ready &&
        readyController != null &&
        readyController.value.isInitialized;

    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (showCamera)
            CameraPreview(readyController)
          else
            const _CameraFallbackPreview(),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).colorScheme.scrim.withValues(alpha: 0.48),
                  Colors.transparent,
                  Theme.of(context).colorScheme.scrim.withValues(alpha: 0.62),
                ],
              ),
            ),
          ),
          Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: scanning ? 334 : 318,
              height: scanning ? 238 : 218,
              decoration: BoxDecoration(
                border: Border.all(
                  color: scanning
                      ? VaaniTheme.secondaryContainer
                      : Theme.of(context).colorScheme.onSurface,
                  width: 4,
                ),
                borderRadius: BorderRadius.circular(22),
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            top: 20,
            child: Row(
              children: [
                Expanded(
                  child: _ScannerStatusChip(state: state, scanning: scanning),
                ),
                const SizedBox(width: 12),
                IconButton.filledTonal(
                  tooltip: flashOn ? 'Turn flash off' : 'Turn flash on',
                  onPressed: onToggleFlash,
                  icon: Icon(
                    flashOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
                  ),
                ),
              ],
            ),
          ),
          if (state != _ScannerCameraState.ready)
            Positioned(
              left: 24,
              right: 24,
              top: 92,
              child: VaaniCard(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state == _ScannerCameraState.loading
                          ? 'Starting camera...'
                          : 'Camera preview unavailable',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'The scanner keeps the review workflow active and will show the live camera when device permissions are available.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: onRetryCamera,
                      icon: const Icon(Icons.camera_alt_outlined),
                      label: const Text('Retry camera'),
                    ),
                  ],
                ),
              ),
            ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 34,
            child: FilledButton.icon(
              onPressed: onScan,
              icon: Icon(scanning ? Icons.radar_rounded : Icons.camera_alt),
              label: Text(scanning ? 'Scanning invoice...' : 'Capture invoice'),
            ),
          ),
        ],
      ),
    );
  }
}

class _CameraFallbackPreview extends StatelessWidget {
  const _CameraFallbackPreview();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [scheme.surfaceContainerHighest, scheme.surface],
            ),
          ),
        ),
        Center(
          child: Transform.rotate(
            angle: -0.06,
            child: Container(
              width: 228,
              height: 318,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: scheme.scrim.withValues(alpha: 0.38),
                    blurRadius: 36,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'INVOICE',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 18),
                  for (var i = 0; i < 7; i++) ...[
                    Container(
                      height: 10,
                      width: i.isEven ? 150 : 112,
                      decoration: BoxDecoration(
                        color: scheme.outlineVariant,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  const Spacer(),
                  Container(
                    height: 14,
                    width: 180,
                    decoration: BoxDecoration(
                      color: scheme.outlineVariant,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ScannerStatusChip extends StatelessWidget {
  const _ScannerStatusChip({required this.state, required this.scanning});

  final _ScannerCameraState state;
  final bool scanning;

  @override
  Widget build(BuildContext context) {
    final label = scanning
        ? 'Reading invoice'
        : switch (state) {
            _ScannerCameraState.ready => 'Live camera',
            _ScannerCameraState.loading => 'Opening camera',
            _ScannerCameraState.empty => 'No camera found',
            _ScannerCameraState.mock => 'Preview mode',
          };
    return Align(
      alignment: Alignment.centerLeft,
      child: Chip(
        avatar: Icon(
          scanning ? Icons.radar_rounded : Icons.document_scanner_outlined,
          size: 18,
        ),
        label: Text(label),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
    );
  }
}

class _InvoiceItem extends StatelessWidget {
  const _InvoiceItem({required this.item, required this.onChanged});

  final _InvoiceItemUi item;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return VaaniCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Checkbox(
            value: item.selected,
            onChanged: (value) => onChanged(value ?? false),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor:
                VaaniTheme.secondaryContainer.withValues(alpha: 0.35),
            child: Icon(item.icon, color: VaaniTheme.secondary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: Theme.of(context).textTheme.titleMedium),
                Text(item.qty),
              ],
            ),
          ),
          Text(item.amount, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}

class _InvoiceItemUi {
  _InvoiceItemUi({
    required this.icon,
    required this.name,
    required this.qty,
    required this.amount,
  });

  final IconData icon;
  final String name;
  final String qty;
  final String amount;
  bool selected = true;

  _InvoiceItemUi copyWith({
    IconData? icon,
    String? name,
    String? qty,
    String? amount,
    bool? selected,
  }) {
    return _InvoiceItemUi(
      icon: icon ?? this.icon,
      name: name ?? this.name,
      qty: qty ?? this.qty,
      amount: amount ?? this.amount,
    )..selected = selected ?? this.selected;
  }
}

final _defaultInvoiceItems = <_InvoiceItemUi>[
  _InvoiceItemUi(
    icon: Icons.shopping_bag_outlined,
    name: 'Rice (Premium 25kg)',
    qty: 'Qty: 10 bags',
    amount: 'Rs 8,500',
  ),
  _InvoiceItemUi(
    icon: Icons.water_drop_outlined,
    name: 'Mustard Oil (1L)',
    qty: 'Qty: 24 units',
    amount: 'Rs 3,950',
  ),
];

const _sampleInvoiceText = '''
Vaani Super Mart
Invoice No: INV-2042
Date: 20-06-2026
GSTIN: 29ABCDE1234F1Z5
Rice Premium 25kg 10 bags 8500
Mustard Oil 1L 24 units 3950
Total: 12450
''';

String _formatAmount(Object? value) {
  if (value is num) {
    return 'Rs ${value.toDouble().toStringAsFixed(value is int ? 0 : 2)}';
  }
  return 'Rs ${value ?? '-'}';
}

enum _ScannerCameraState { loading, ready, empty, mock }
