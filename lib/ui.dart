import 'package:flutter/material.dart';
import 'data.dart';

class C {
  static const bg = Color(0xFF0B0A11);
  static const s1 = Color(0xFF14121D);
  static const s2 = Color(0xFF1D1A2B);
  static const tx = Color(0xFFF4F2FB);
  static const mt = Color(0xFF8C87A3);
  static const p = Color(0xFF6D3BEA);
  static const pl = Color(0xFFA892F6);
  static const line = Color(0xFF3A3552);
  static const ring = Color(0xFF5D587A);
  static const halo = Color(0x486D3BEA);
}

TextStyle poppins(double size,
        {FontWeight w = FontWeight.w600, Color c = C.tx, double? h, double ls = -0.02}) =>
    TextStyle(
        fontFamily: 'Poppins',
        fontSize: size,
        fontWeight: w,
        color: c,
        height: h,
        letterSpacing: size * ls);

TextStyle inter(double size,
        {FontWeight w = FontWeight.w400, Color c = C.tx, double? h}) =>
    TextStyle(fontFamily: 'Inter', fontSize: size, fontWeight: w, color: c, height: h);

/// Logo "beyond" oficial (imagem enviada pelo Vitor, sem recriar).
class ByLogo extends StatelessWidget {
  final double size;
  const ByLogo(this.size, {super.key});
  @override
  Widget build(BuildContext context) =>
      Image.asset('assets/logo_beyond.png', height: size * 1.05, fit: BoxFit.contain);
}

class KyLogo extends StatelessWidget {
  final double size;
  const KyLogo(this.size, {super.key});
  @override
  Widget build(BuildContext context) {
    final st = TextStyle(
        fontFamily: 'Quicksand', fontSize: size, color: Colors.white, height: 1.1);
    return Row(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: [
      Text('keep', style: st),
      SizedBox(width: size * 0.16),
      Container(
        padding: EdgeInsets.fromLTRB(size * 0.2, size * 0.04, size * 0.24, size * 0.06),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(size * 0.10),
                topRight: Radius.circular(size * 0.62),
                bottomRight: Radius.circular(size * 0.10),
                bottomLeft: Radius.circular(size * 0.62))),
        child: Text('You', style: st.copyWith(color: const Color(0xFF17402F))),
      ),
    ]);
  }
}

class UpLogo extends StatelessWidget {
  final double size;
  const UpLogo(this.size, {super.key});
  @override
  Widget build(BuildContext context) =>
      Image.asset('assets/logo_up.png', height: size * 1.55, fit: BoxFit.contain);
}

Widget logoDe(Proj p, double size) => p == Proj.up ? UpLogo(size) : KyLogo(size);

String nomeDe(Proj p) => p == Proj.up ? 'UpYou' : 'keepYou';

/// Marca de estado. So usa roxo: vazada = normal, cheia = pede voce, com halo = ao vivo.
class Marca extends StatelessWidget {
  final Estado e;
  const Marca(this.e, {super.key});
  @override
  Widget build(BuildContext context) {
    switch (e) {
      case Estado.online:
        return Container(
            width: 18,
            height: 18,
            alignment: Alignment.center,
            decoration: const BoxDecoration(color: C.halo, shape: BoxShape.circle),
            child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(color: C.p, shape: BoxShape.circle)));
      case Estado.espera:
        return Container(
            width: 18,
            height: 18,
            alignment: Alignment.center,
            child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(color: C.p, shape: BoxShape.circle)));
      case Estado.offline:
        return Container(
            width: 18,
            height: 18,
            alignment: Alignment.center,
            child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, border: Border.all(color: C.ring, width: 1.8))));
    }
  }
}

class Btn extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool primary;
  final bool small;
  final bool full;
  const Btn(this.label, this.onTap,
      {super.key, this.primary = true, this.small = false, this.full = false});
  @override
  Widget build(BuildContext context) {
    final h = small ? 34.0 : 44.0;
    final child = Container(
      height: h,
      padding: EdgeInsets.symmetric(horizontal: small ? 16 : 22),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: primary ? C.p : Colors.transparent,
          borderRadius: BorderRadius.circular(h / 2),
          border: primary ? null : Border.all(color: C.line, width: 1.5)),
      child: Text(label,
          style: inter(small ? 12.5 : 14.5, w: FontWeight.w600, c: Colors.white)),
    );
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: full ? SizedBox(width: double.infinity, child: child) : child,
      ),
    );
  }
}

class Tag extends StatelessWidget {
  final String t;
  const Tag(this.t, {super.key});
  @override
  Widget build(BuildContext context) => Text(t.toUpperCase(),
      style: inter(11.5, w: FontWeight.w600, c: C.mt).copyWith(letterSpacing: 0.9));
}

class Linha extends StatelessWidget {
  final Pessoa p;
  final VoidCallback onTap;
  final bool compacto;
  const Linha(this.p, this.onTap, {super.key, this.compacto = false});
  @override
  Widget build(BuildContext context) {
    final destaque = p.estado != Estado.offline;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: EdgeInsets.symmetric(horizontal: compacto ? 12 : 20, vertical: compacto ? 10 : 14),
          decoration: BoxDecoration(color: C.s1, borderRadius: BorderRadius.circular(compacto ? 16 : 18)),
          child: Row(children: [
            Marca(p.estado),
            SizedBox(width: compacto ? 8 : 16),
            Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(p.nome, style: poppins(compacto ? 13 : 17)),
              const SizedBox(height: 2),
              Text(p.detalhe, style: inter(compacto ? 11 : 14, c: C.mt)),
            ])),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(
                  p.estado == Estado.online
                      ? 'Online agora'
                      : p.estado == Estado.espera
                          ? 'Espera você'
                          : 'Offline',
                  style: inter(compacto ? 11.5 : 14.5,
                      w: FontWeight.w500, c: destaque ? C.pl : C.tx)),
              if (!compacto) ...[
                const SizedBox(height: 2),
                Text(p.quando, style: inter(13, c: C.mt)),
              ]
            ]),
          ]),
        ),
      ),
    );
  }
}

class ItemFeed extends StatelessWidget {
  final Evento e;
  final bool novo;
  final bool compacto;
  const ItemFeed(this.e, {super.key, this.novo = false, this.compacto = false});
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      margin: const EdgeInsets.only(bottom: 2),
      padding: EdgeInsets.symmetric(horizontal: compacto ? 12 : 16, vertical: compacto ? 9 : 13),
      decoration: BoxDecoration(
          color: novo ? C.s2 : Colors.transparent, borderRadius: BorderRadius.circular(16)),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(width: compacto ? 40 : 46, child: Text(e.hora, style: inter(compacto ? 12 : 13, w: FontWeight.w500, c: C.mt))),
        SizedBox(
            width: 28,
            child: Text(e.proj == Proj.up ? 'UP' : 'KY',
                style: inter(10.5, w: FontWeight.w600, c: C.mt).copyWith(letterSpacing: 0.6))),
        Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(e.texto, style: inter(compacto ? 12.5 : 14.5, w: FontWeight.w500, h: 1.4)),
          if (e.sub != null)
            Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(e.sub!, style: inter(compacto ? 11.5 : 13, c: C.mt))),
        ])),
      ]),
    );
  }
}

class StatusLinha extends StatelessWidget {
  final String t;
  final bool aviso;
  const StatusLinha(this.t, {super.key, this.aviso = false});
  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
        Marca(aviso ? Estado.espera : Estado.offline),
        const SizedBox(width: 4),
        Text(t, style: inter(13.5, w: FontWeight.w500, c: aviso ? C.pl : C.mt)),
      ]);
}
