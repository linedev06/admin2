import 'package:flutter/material.dart';
import '../data.dart';
import '../ui.dart';
import '../main.dart';

class HojeScreen extends StatelessWidget {
  final Repo repo;
  final bool desktop;
  final void Function(Aba) ir;
  const HojeScreen({super.key, required this.repo, required this.desktop, required this.ir});

  static const _dias = ['Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado', 'Domingo'];
  static const _meses = [
    'janeiro', 'fevereiro', 'março', 'abril', 'maio', 'junho',
    'julho', 'agosto', 'setembro', 'outubro', 'novembro', 'dezembro'
  ];

  String get _data {
    final n = DateTime.now();
    return '${_dias[n.weekday - 1]}, ${n.day} de ${_meses[n.month - 1]}';
  }

  String get _frase {
    final n = repo.pendencias;
    if (n == 0) return 'Nada espera ';
    if (n == 1) return 'Uma coisa espera ';
    if (n == 2) return 'Duas coisas esperam ';
    if (n == 3) return 'Três coisas esperam ';
    return '$n coisas esperam ';
  }

  Widget _titulo() {
    final s = desktop ? 52.0 : 26.0;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Tag(_data),
      SizedBox(height: desktop ? 16 : 10),
      Text('Tudo no ar.', style: poppins(s, h: 1.08)),
      RichText(
          text: TextSpan(style: poppins(s, h: 1.08), children: [
        TextSpan(text: _frase),
        TextSpan(text: 'por você.', style: poppins(s, h: 1.08, c: C.pl)),
      ])),
    ]);
  }

  Widget _pendencia(String titulo, String sub, Widget b1, Widget b2) {
    return Padding(
      padding: EdgeInsets.only(bottom: desktop ? 26 : 18),
      child: desktop
          ? Row(children: [
              const Padding(padding: EdgeInsets.only(right: 14, bottom: 22), child: Marca(Estado.espera)),
              Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(titulo, style: poppins(21, h: 1.3)),
                const SizedBox(height: 3),
                Text(sub, style: inter(15, c: C.mt)),
              ])),
              b1,
              const SizedBox(width: 10),
              b2,
            ])
          : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Padding(padding: EdgeInsets.only(top: 1, right: 8), child: Marca(Estado.espera)),
                Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(titulo, style: poppins(15, h: 1.3)),
                  const SizedBox(height: 2),
                  Text(sub, style: inter(12, c: C.mt)),
                ])),
              ]),
              const SizedBox(height: 10),
              Padding(
                  padding: const EdgeInsets.only(left: 26),
                  child: Row(children: [b1, const SizedBox(width: 8), b2])),
            ]),
    );
  }

  List<Widget> _pendencias() {
    final out = <Widget>[];
    for (final p in repo.pedidos.take(3)) {
      out.add(_pendencia(
        '${p.nome} pediu acesso ao ${nomeDe(p.proj)}',
        '${p.sub.split(',').first}, pediu ${p.quando}',
        Btn('Aprovar', () => repo.aprovar(p), small: !desktop),
        Btn(desktop ? 'Ver pedido' : 'Ver', () => ir(Aba.acessos), primary: false, small: !desktop),
      ));
    }
    for (final c in repo.cobrancas.where((c) => c.atrasada && !c.recebida)) {
      out.add(_pendencia(
        '${c.nome} está com o Pix atrasado',
        '${nomeDe(c.proj)}. O acesso pausa amanhã às 08:00 se não pagar',
        Btn('Lembrar', () => repo.lembrar(c), small: !desktop),
        Btn('Ver', () => ir(Aba.cobrancas), primary: false, small: !desktop),
      ));
    }
    return out;
  }

  Widget _projeto(Proj p) {
    final up = p == Proj.up;
    final frase = up
        ? '${repo.upPersonaisAgora} personais e ${repo.upAlunosAgora} alunos usando agora'
        : '${repo.kyNutriAgora} nutricionistas e ${repo.kyPacientesAgora} pacientes usando agora';
    final l1 = up
        ? '${repo.upAulasHoje} aulas hoje e ${repo.upAvisos} avisos enviados.'
        : '${repo.kyConsultas} consultas hoje e ${repo.kyRespostasIa} respostas da IA aprovadas.';
    final l2 = up ? 'Última cobrança paga há 4 minutos.' : 'Um teste novo começou há 8 minutos.';
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => ir(up ? Aba.upyou : Aba.keepyou),
        behavior: HitTestBehavior.opaque,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          logoDe(p, desktop ? 26 : 15),
          SizedBox(height: desktop ? 16 : 8),
          Text(frase, style: poppins(desktop ? 24 : 15, h: 1.25)),
          const SizedBox(height: 8),
          Text('$l1\n$l2', style: inter(desktop ? 15 : 11.5, c: C.mt, h: 1.55)),
        ]),
      ),
    );
  }

  Widget _status() => Wrap(spacing: 22, runSpacing: 6, children: [
        const StatusLinha('Banco de dados'),
        const StatusLinha('Pagamentos'),
        const StatusLinha('Avisos no celular'),
        if (repo.iaLenta) const StatusLinha('IA mais lenta que o normal', aviso: true),
      ]);

  @override
  Widget build(BuildContext context) {
    if (desktop) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(56, 28, 56, 28),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(right: 56),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _titulo(),
                const SizedBox(height: 44),
                ..._pendencias(),
                const SizedBox(height: 26),
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(child: _projeto(Proj.up)),
                  const SizedBox(width: 40),
                  Expanded(child: _projeto(Proj.ky)),
                ]),
                const SizedBox(height: 36),
                _status(),
              ]),
            ),
          ),
          SizedBox(width: 408, child: FeedPanel(repo: repo)),
        ]),
      );
    }
    return ListView(padding: const EdgeInsets.fromLTRB(22, 20, 22, 24), children: [
      _titulo(),
      const SizedBox(height: 24),
      ..._pendencias(),
      const SizedBox(height: 6),
      _projeto(Proj.up),
      const SizedBox(height: 22),
      _projeto(Proj.ky),
      const SizedBox(height: 26),
      const Tag('Acontecendo agora'),
      const SizedBox(height: 8),
      for (int i = 0; i < repo.eventos.length && i < 8; i++)
        ItemFeed(repo.eventos[i], novo: i == 0, compacto: true),
      const SizedBox(height: 20),
      _status(),
    ]);
  }
}

class FeedPanel extends StatelessWidget {
  final Repo repo;
  const FeedPanel({super.key, required this.repo});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 26, 14, 8),
      decoration: BoxDecoration(color: C.s1, borderRadius: BorderRadius.circular(28)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: Text('Acontecendo agora', style: poppins(22))),
        Expanded(
          child: ListView.builder(
            itemCount: repo.eventos.length,
            itemBuilder: (_, i) => ItemFeed(repo.eventos[i], novo: i == 0),
          ),
        ),
      ]),
    );
  }
}
