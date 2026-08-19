import 'package:flutter/material.dart';
import 'theme.dart';

/// Painel de madeira (equivalente ao `.woodPanel` do CSS): tábuas horizontais,
/// veio nas laterais, gradiente vertical, borda escura e sombra interna.
class WoodPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double? maxWidth;
  final bool showRivets;
  final BorderRadius? borderRadius;

  const WoodPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.s20),
    this.maxWidth = 420,
    this.showRivets = false,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(AppRadius.modal);
    Widget panel = Container(
      constraints: maxWidth != null ? BoxConstraints(maxWidth: maxWidth!) : null,
      decoration: BoxDecoration(
        borderRadius: radius,
        border: Border.all(color: AppColors.woodDark, width: 3),
        boxShadow: AppShadows.modal,
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.woodLight, AppColors.wood, AppColors.woodDark],
          stops: [0.0, 0.55, 1.0],
        ),
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Stack(
          children: [
            // veio das tábuas (linhas horizontais sutis a cada 46px)
            Positioned.fill(
              child: CustomPaint(painter: _WoodGrainPainter()),
            ),
            Padding(padding: padding, child: child),
            if (showRivets) ..._buildRivets(),
          ],
        ),
      ),
    );
    return panel;
  }

  List<Widget> _buildRivets() {
    const d = 10.0;
    return const [
      Positioned(top: d, left: d, child: WoodRivet()),
      Positioned(top: d, right: d, child: WoodRivet()),
      Positioned(bottom: d, left: d, child: WoodRivet()),
      Positioned(bottom: d, right: d, child: WoodRivet()),
    ];
  }
}

class _WoodGrainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // linhas das tábuas
    final linePaint = Paint()
      ..color = const Color(0x0D000000)
      ..strokeWidth = 2;
    for (double y = 0; y < size.height; y += 46) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }
    // sombreado lateral (o gradiente horizontal do CSS)
    final sidePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [Color(0x1F000000), Color(0x00000000), Color(0x00000000), Color(0x1F000000)],
        stops: [0.0, 0.06, 0.94, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), sidePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Rebite metálico dos cantos do painel (`.woodRivet`).
class WoodRivet extends StatelessWidget {
  const WoodRivet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 9,
      height: 9,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          center: Alignment(-0.3, -0.4),
          colors: [Color(0xFFCFCFCF), Color(0xFF6B6B6B), Color(0xFF3A3A3A)],
          stops: [0.0, 0.6, 1.0],
        ),
        boxShadow: [BoxShadow(color: Color(0x80000000), offset: Offset(0, 1), blurRadius: 2)],
      ),
    );
  }
}

enum WoodBtnColor { yellow, blue, green, red, purple, white }

/// Botão estilo "madeira/cartoon" com profundidade 3D (`.woodBtn`).
/// Ao pressionar ele afunda 4px, igual ao `:active` do CSS.
class WoodButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final WoodBtnColor color;
  final bool primary;
  final Widget? icon;
  final bool fullWidth;
  final double? fontSize;

  const WoodButton({
    super.key,
    required this.label,
    this.onPressed,
    this.color = WoodBtnColor.yellow,
    this.primary = false,
    this.icon,
    this.fullWidth = true,
    this.fontSize,
  });

  @override
  State<WoodButton> createState() => _WoodButtonState();
}

class _WoodButtonState extends State<WoodButton> {
  bool _pressed = false;

  ({Color base, Color shadow, Color text}) get _palette {
    switch (widget.color) {
      case WoodBtnColor.yellow:
        return (base: AppColors.cornYellow, shadow: AppColors.shadowYellow, text: Colors.white);
      case WoodBtnColor.blue:
        return (base: AppColors.accentBlue, shadow: AppColors.shadowBlue, text: Colors.white);
      case WoodBtnColor.green:
        return (base: AppColors.accentGreen, shadow: AppColors.shadowGreen, text: Colors.white);
      case WoodBtnColor.red:
        return (base: AppColors.accentRed, shadow: AppColors.shadowRed, text: Colors.white);
      case WoodBtnColor.purple:
        return (base: AppColors.accentPurple, shadow: AppColors.shadowPurple, text: Colors.white);
      case WoodBtnColor.white:
        return (base: Colors.white, shadow: AppColors.shadowWhite, text: AppColors.darkBrown);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = _palette;
    final enabled = widget.onPressed != null;
    final depth = _pressed ? 1.0 : 5.0;
    final dy = _pressed ? 4.0 : 0.0;

    final style = (widget.primary ? AppTypography.buttonLabelPrimary : AppTypography.buttonLabel)
        .copyWith(
      color: p.text,
      fontSize: widget.fontSize,
      shadows: widget.color == WoodBtnColor.white ? const [] : null,
    );

    Widget content = Row(
      mainAxisSize: widget.fullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.icon != null) ...[
          SizedBox(width: 20, height: 20, child: widget.icon),
          const SizedBox(width: AppSpacing.s8),
        ],
        Flexible(
          child: Text(widget.label, textAlign: TextAlign.center, style: style, overflow: TextOverflow.ellipsis),
        ),
      ],
    );

    return Opacity(
      opacity: enabled ? 1 : 0.55,
      child: GestureDetector(
        onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
        onTapUp: enabled ? (_) => setState(() => _pressed = false) : null,
        onTapCancel: enabled ? () => setState(() => _pressed = false) : null,
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 90),
          transform: Matrix4.translationValues(0, dy, 0),
          padding: widget.primary
              ? const EdgeInsets.symmetric(vertical: 18, horizontal: 44)
              : const EdgeInsets.symmetric(vertical: 16, horizontal: 30),
          decoration: BoxDecoration(
            color: p.base,
            borderRadius: BorderRadius.circular(widget.primary ? 20 : AppRadius.button),
            border: Border.all(color: AppColors.woodDark, width: 3),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white.withOpacity(0.18), p.base],
              stops: const [0.0, 0.4],
            ),
            boxShadow: [
              BoxShadow(color: p.shadow, offset: Offset(0, depth)),
              BoxShadow(
                color: const Color(0x47000000),
                offset: Offset(0, depth + 4),
                blurRadius: 14,
              ),
            ],
          ),
          child: content,
        ),
      ),
    );
  }
}

/// Botão circular de ícone (`.woodIconBtn`) — usado na linha de ícones do menu.
class WoodIconButton extends StatefulWidget {
  final Widget icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final double size;
  final Color? background;
  final bool highlighted;

  const WoodIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.size = 52,
    this.background,
    this.highlighted = false,
  });

  @override
  State<WoodIconButton> createState() => _WoodIconButtonState();
}

class _WoodIconButtonState extends State<WoodIconButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final bg = widget.background ?? AppColors.woodLight;
    final depth = _pressed ? 1.0 : 4.0;
    final dy = _pressed ? 3.0 : 0.0;

    Widget btn = GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 90),
        transform: Matrix4.translationValues(0, dy, 0),
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: bg,
          border: Border.all(
            color: widget.highlighted ? AppColors.cornYellow : AppColors.woodDark,
            width: 3,
          ),
          gradient: RadialGradient(
            center: const Alignment(-0.3, -0.4),
            colors: [bg.withOpacity(1), _darken(bg, 0.18)],
          ),
          boxShadow: [
            BoxShadow(color: AppColors.woodDark, offset: Offset(0, depth)),
            BoxShadow(color: const Color(0x40000000), offset: Offset(0, depth + 2), blurRadius: 8),
          ],
        ),
        child: Center(
          child: SizedBox(width: widget.size * 0.42, height: widget.size * 0.42, child: widget.icon),
        ),
      ),
    );

    if (widget.tooltip != null) {
      btn = Tooltip(message: widget.tooltip!, child: btn);
    }
    return btn;
  }

  Color _darken(Color c, double amount) {
    final hsl = HSLColor.fromColor(c);
    return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
  }
}

/// Botão X vermelho do canto dos modais (`.gameCloseBtn`).
class GameCloseButton extends StatelessWidget {
  final VoidCallback onPressed;
  const GameCloseButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return WoodIconButton(
      size: 38,
      background: AppColors.accentRed,
      onPressed: onPressed,
      icon: const Icon(Icons.close, color: Colors.white, size: 16),
    );
  }
}

/// Estrutura padrão dos modais do jogo: cabeçalho fixo, corpo rolável e
/// botão de fechar fixo no rodapé — exatamente o layout que ajustamos na
/// versão web (loja, conquistas, estatísticas).
class WoodModal extends StatelessWidget {
  final String title;
  final Widget? header;
  final Widget body;
  final VoidCallback onClose;
  final String closeLabel;

  const WoodModal({
    super.key,
    required this.title,
    required this.body,
    required this.onClose,
    this.header,
    this.closeLabel = 'FECHAR',
  });

  @override
  Widget build(BuildContext context) {
    final maxH = MediaQuery.of(context).size.height * 0.82;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s20),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxH, maxWidth: 420),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              WoodPanel(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title, style: AppTypography.h2, textAlign: TextAlign.center),
                    if (header != null) ...[const SizedBox(height: AppSpacing.s8), header!],
                    const SizedBox(height: AppSpacing.s12),
                    Flexible(child: SingleChildScrollView(child: body)),
                    const SizedBox(height: AppSpacing.s12),
                    WoodButton(label: closeLabel, color: WoodBtnColor.red, onPressed: onClose),
                  ],
                ),
              ),
              Positioned(top: 8, right: 8, child: GameCloseButton(onPressed: onClose)),
            ],
          ),
        ),
      ),
    );
  }
}
