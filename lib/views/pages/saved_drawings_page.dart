import 'package:flutter/material.dart';

import '../../core/di/injection_container.dart';
import '../../core/routes/fade_slide_route.dart';
import '../../models/reiki_symbol.dart';
import '../../models/saved_drawing.dart';
import '../../repositories/drawing_save_repository.dart';
import '../../viewmodels/drawing/drawing_event.dart';
import 'drawing_page.dart';

class SavedDrawingsPage extends StatefulWidget {
  final ReikiSymbol symbol;
  const SavedDrawingsPage({super.key, required this.symbol});

  @override
  State<SavedDrawingsPage> createState() => _SavedDrawingsPageState();
}

class _SavedDrawingsPageState extends State<SavedDrawingsPage> {
  late Future<List<SavedDrawing>> _future;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    setState(() {
      _future = sl<DrawingSaveRepository>().loadAll(widget.symbol.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final hPadding = (w * 0.05).clamp(16.0, 64.0);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Meus Desenhos'),
            Text(
              widget.symbol.name,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: const Color(0xFFB388FF)),
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<SavedDrawing>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final drawings = snapshot.data ?? [];
          if (drawings.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.bookmark_border,
                      size: 72, color: Color(0xFF3D2060)),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhum desenho salvo ainda',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.white38),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Use o ícone  ao desenhar para salvar.',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.white24),
                  ),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: EdgeInsets.symmetric(
                horizontal: hPadding, vertical: 20),
            itemCount: drawings.length,
            separatorBuilder: (context, i) => const SizedBox(height: 10),
            itemBuilder: (context, i) => _DrawingCard(
              drawing: drawings[i],
              symbol: widget.symbol,
              onDeleted: _load,
            ),
          );
        },
      ),
    );
  }
}

class _DrawingCard extends StatelessWidget {
  final SavedDrawing drawing;
  final ReikiSymbol symbol;
  final VoidCallback onDeleted;

  const _DrawingCard({
    required this.drawing,
    required this.symbol,
    required this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    final d = drawing.savedAt;
    final dateStr =
        '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}  '
        '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF2D1B4E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3D2060)),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF3D2060),
            ),
            child: const Icon(Icons.gesture,
                color: Color(0xFFB388FF), size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(drawing.name,
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 3),
                Text(
                  '$dateStr  ·  ${drawing.strokes.length} traço${drawing.strokes.length != 1 ? 's' : ''}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFFB388FF),
                      ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.open_in_new,
                color: Color(0xFF80DEEA), size: 20),
            tooltip: 'Abrir',
            onPressed: () => Navigator.of(context).push(FadeSlideRoute(
              page: DrawingPage(
                symbol: symbol,
                mode: DrawingMode.verificar,
                initialStrokes: drawing.strokes,
              ),
            )),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline,
                color: Colors.redAccent, size: 20),
            tooltip: 'Excluir',
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir desenho'),
        content: Text('Deseja excluir "${drawing.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              await sl<DrawingSaveRepository>().delete(drawing.id);
              if (ctx.mounted) Navigator.pop(ctx);
              onDeleted();
            },
            child: const Text('Excluir',
                style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}
