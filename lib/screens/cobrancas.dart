import 'package:flutter/material.dart';
import '../data.dart';
import '../ui.dart';

class CobrancasScreen extends StatelessWidget {
  final Repo repo;
  final bool desktop;
  const CobrancasScreen({super.key, required this.repo, required this.desktop});

  Widget _linha(Cobranca c) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: desktop ? 12 : 9, horizontal: desktop ? 16 : 0),
      child: Row(children: [
        SizedBox(
            width: 30,
            child: Text(c.proj == Proj.up ? 'UP' : 'KY',
                style: inter(10.5, w: FontWeight.w600, c: C.mt).copyWith(letterSpacing: 0.6))),
        Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(c.nome, style: poppins(desktop ? 17 : 13)),
          const SizedBox(height: 1),
          Text(c.sub, style: inter(desktop ? 14 : 11, c: C.mt)),
        ])),
        Text(reais(c.valor),
            style: inter(desktop ? 16 : 12.5, w: FontWeight.w600, c: c.atrasada ? C.pl : C.tx)),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pend = repo.cobrancas.where((c) => !c.recebida).toList();
    final rec = repo.cobrancas.where((c) => c.recebida).toList();
    final atrasada = pend.where((c) => c.atrasada).toList();
    final total = 'R\$ ${milhar(repo.recebidoTotal)}';

    final titulo = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Tag('Outubro'),
      SizedBox(height: desktop ? 14 : 6),
      Text('$total recebidos.', style: poppins(desktop ? 56 : 24, h: 1.05)),
      if (desktop) Text('Falta pouco.', style: poppins(56, h: 1.05, c: C.pl)),
      const SizedBox(height: 12),
      Text(
          'R\$ ${repo.recebidoUp} do UpYou e R\$ ${repo.recebidoKy} do keepYou. '
          '${pend.length} cobranças aguardam${atrasada.isNotEmpty ? ', uma delas atrasada' : ''}.',
          style: inter(desktop ? 18 : 11.5, c: C.mt, h: 1.5)),
    ]);

    final listas = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(padding: EdgeInsets.only(left: desktop ? 16 : 0), child: const Tag('Pendentes')),
      const SizedBox(height: 6),
      for (final c in pend) _linha(c),
      const SizedBox(height: 22),
      Padding(padding: EdgeInsets.only(left: desktop ? 16 : 0), child: const Tag('Recebidos hoje')),
      const SizedBox(height: 6),
      for (final c in rec) _linha(c),
    ]);

    if (desktop) {
      final c = atrasada.isEmpty ? null : atrasada.first;
      return Padding(
        padding: const EdgeInsets.fromLTRB(56, 28, 56, 28),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
              child: SingleChildScrollView(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            titulo,
            const SizedBox(height: 40),
            SizedBox(width: 640, child: listas),
          ]))),
          const SizedBox(width: 48),
          SizedBox(
              width: 408,
              child: Container(
                padding: const EdgeInsets.fromLTRB(30, 34, 30, 34),
                decoration: BoxDecoration(color: C.s1, borderRadius: BorderRadius.circular(28)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  if (c != null) ...[
                    const Tag('Ação sugerida'),
                    const SizedBox(height: 12),
                    Text('Lembrar ${c.nome.split(' ').first} antes de pausar o acesso',
                        style: poppins(26, h: 1.2)),
                    const SizedBox(height: 12),
                    Text(
                        'Ela abriu o app hoje cedo e costuma pagar no dia seguinte ao aviso. Um lembrete agora evita a pausa.',
                        style: inter(15, c: C.mt, h: 1.6)),
                    const SizedBox(height: 24),
                    Btn('Enviar lembrete', () => repo.lembrar(c), full: true),
                    const SizedBox(height: 10),
                    Btn('Pausar mesmo assim', () {}, primary: false, full: true),
                    const SizedBox(height: 40),
                  ] else ...[
                    Text('Nenhuma cobrança atrasada.', style: poppins(22, h: 1.2)),
                    const SizedBox(height: 40),
                  ],
                  const Tag('Próximos vencimentos'),
                  const SizedBox(height: 10),
                  for (final v in const [['Amanhã', '2 cobranças'], ['Quinta', '3 cobranças'], ['Sexta', '1 cobrança']])
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        child: Row(children: [
                          SizedBox(width: 80, child: Text(v[0], style: inter(16, w: FontWeight.w500))),
                          Text(v[1], style: inter(16, c: C.mt)),
                        ])),
                ]),
              )),
        ]),
      );
    }
    return ListView(padding: const EdgeInsets.fromLTRB(22, 22, 22, 24), children: [
      Text('Cobranças', style: poppins(26)),
      const SizedBox(height: 18),
      titulo,
      const SizedBox(height: 24),
      listas,
    ]);
  }
}
