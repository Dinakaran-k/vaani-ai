import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app/theme.dart';
import '../../../shared/presentation/vaani_shell.dart';

class OcrScreen extends StatefulWidget {
  const OcrScreen({super.key, this.cameraEnabled = true});

  final bool cameraEnabled;

  @override
  State<OcrScreen> createState() => _OcrScreenState();
}

class _OcrScreenState extends State<OcrScreen> {
  CameraController? _cameraController;
  var _cameraState = _ScannerCameraState.loading;
  var _scanning = false;
  var _flashOn = false;
  final _invoiceItems = <_InvoiceItemUi>[
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

  @override
  void initState() {
    super.initState();
    if (widget.cameraEnabled) {
      _initializeCamera();
    } else {
      _cameraState = _ScannerCameraState.mock;
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
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
                return Container(
                  decoration: const BoxDecoration(
                    color: VaaniTheme.surface,
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
                            color: const Color(0xFFC7C4D7),
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
                            labelStyle: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Confirm extracted items before they touch inventory.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: VaaniTheme.onSurfaceVariant,
                            ),
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
                                  : () => showVaaniSnackBar(
                                        context,
                                        '$selectedCount items queued for inventory',
                                      ),
                              icon: const Icon(Icons.add_business_outlined),
                              label: const Text('Add items'),
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
      await _cameraController?.dispose();
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
    setState(() => _scanning = true);
    await Future<void>.delayed(const Duration(milliseconds: 650));
    if (!mounted) return;
    setState(() {
      _scanning = false;
      for (final item in _invoiceItems) {
        item.selected = true;
      }
    });
    showVaaniSnackBar(context, 'Invoice scan refreshed');
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
      decoration: const BoxDecoration(color: Color(0xFF10111A)),
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
                  Colors.black.withValues(alpha: 0.50),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.62),
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
                  color:
                      scanning ? VaaniTheme.secondaryContainer : Colors.white,
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
                color: Colors.white.withValues(alpha: 0.92),
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
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF303038), Color(0xFF0F172A)],
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
                color: const Color(0xFFF7F2EA),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.38),
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
                        color: const Color(0xFFD8D2C7),
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
                      color: const Color(0xFFCAC3B8),
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
        backgroundColor: Colors.white,
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
}

enum _ScannerCameraState { loading, ready, empty, mock }
