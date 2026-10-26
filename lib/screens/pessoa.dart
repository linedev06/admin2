import 'package:flutter/material.dart';
import '../data.dart';
import '../ui.dart';

class PessoaScreen extends StatelessWidget {
  final Repo repo;
  final Pessoa pessoa;
  const PessoaScreen({super.key, required this.repo, required this.pessoa});

  @override
  Widget build(BuildContext context) {
    final desktop = MediaQuery.of(context).size.width >= 900;
    return AnimatedBuilder(
      animation: repo,
      builder: (context, _) {
        final p = pessoa;
        final eventos = repo.eventos.where((e) => e.texto.contains(p.nome)).toList();
        final estado = p.estado == Estado.online
            ? 'No app agora, ${p.quando.replaceFirst('No app ', '')}'
            : p.estado == Estado.espera
                ? 'Espera você, ${p.quando}'
                : p.quando;
        final topo = Row(children: [
          GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Text('‹', style: inter(26, c: C.mt))),
          const SizedBox(width: 12),
          logoDe(p.proj, desktop ? 15 : 14),
          const SizedBox(width: 10),
          Text(p.proj == Proj.up ? 'Personais' : 'Nutricionistas', style: inter(14, w: FontWeight.w500, c: C.mt)),
        ]);
        final info = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(p.nome, style: poppins(desktop ? 56 : 30, h: 1.05)),
          const SizedBox(height: 14),
          Row(children: [
            Marca(p.estado),
            const SizedBox(width: 6),
            Text(estado, style: inter(desktop ? 18 : 13, w: FontWeight.w500, c: C.pl)),
          ]),
          SizedBox(height: desktop ? 40 : 22),
          for (final l in p.linhas)
            Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(l, style: inter(desktop ? 18 : 13.5, h: 1.6))),
          SizedBox(height: desktop ? 36 : 20),
          Wrap(spacing: 10, runSpacing: 10, children: [
            Btn('Enviar aviso', () {
              repo.avisar(p);
            }, small: !desktop),
            Btn('Ver alunos', () {}, primary: false, small: !desktop),
            Btn('Pausar acesso', () {
              repo.pausar(p);
            }, primary: false, small: !desktop),
          ]),
        ]);
        final feed = Container(
          padding: const EdgeInsets.fromLTRB(14, 26, 14, 8),
          decoration: BoxDecoration(color: C.s1, borderRadius: BorderRadius.circular(28)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                child: Text('Hoje com ${p.nome.split(' ').first}', style: poppins(22))),
            if (eventos.isEmpty)
              Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Nada novo por enquanto. Os próximos eventos aparecem aqui.',
                      style: inter(14, c: C.mt, h: 1.5))),
            Expanded(
                child: ListView(children: [
              for (int i = 0; i < eventos.length; i++) ItemFeed(eventos[i], novo: i == 0),
            ])),
          ]),
        );
        return Scaffold(
          backgroundColor: C.bg,
          body: SafeArea(
            child: desktop
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(56, 28, 56, 28),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      topo,
                      const SizedBox(height: 40),
                      Expanded(
                          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Expanded(child: SingleChildScrollView(child: info)),
                        const SizedBox(width: 56),
                        SizedBox(width: 468, child: feed),
                      ])),
                    ]))
                : ListView(padding: const EdgeInsets.fromLTRB(22, 14, 22, 24), children: [
                    topo,
                    const SizedBox(height: 22),
                    info,
                    const SizedBox(height: 28),
                    const Tag('Hoje'),
                    const SizedBox(height: 8),
                    for (int i = 0; i < eventos.length; i++)
                      ItemFeed(eventos[i], novo: i == 0, compacto: true),
                  ]),
          ),
        );
      },
    );
  }
}
