import 'package:flutter/material.dart';
import '../data.dart';
import '../ui.dart';
import '../main.dart';
import 'pessoa.dart';

class ProjetoScreen extends StatelessWidget {
  final Repo repo;
  final Proj proj;
  final bool desktop;
  final void Function(Aba) ir;
  const ProjetoScreen(
      {super.key, required this.repo, required this.proj, required this.desktop, required this.ir});

  bool get up => proj == Proj.up;

  void _abrir(BuildContext context, Pessoa p) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => PessoaScreen(repo: repo, pessoa: p)));
  }

  Widget _blocos() {
    final b1 = up
        ? ['Hoje no app', '${repo.upAulasHoje} aulas, ${repo.upAvisos} avisos',
            'Os alunos confirmaram 71 presenças. 12 avisos de aula saíram para amanhã.']
        : ['Hoje no app', '${repo.kyConsultas} consultas, ${repo.kyRespostasIa} respostas da IA',
            'As nutricionistas revisaram todos os rascunhos antes de enviar. 3 respostas demoraram mais que o normal.'];
    final b2 = up
        ? ['Planos', '14 Essencial, 6 Gestão, 4 Pro', 'Rota (Wayfit) está ligado em 7 contas.']
        : ['Planos', '7 Inicial, 2 Pro', '5 pessoas na lista de espera do plano Clínicas.'];
    Widget bloco(List<String> b) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Tag(b[0]),
          SizedBox(height: desktop ? 12 : 6),
          Text(b[1], style: poppins(desktop ? 30 : 17, h: 1.15)),
          const SizedBox(height: 8),
          Text(b[2], style: inter(desktop ? 16 : 11.5, c: C.mt, h: 1.5)),
        ]);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      bloco(b1),
      SizedBox(height: desktop ? 40 : 20),
      bloco(b2),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final frase = up
        ? '${repo.upPersonaisAgora} personais e ${repo.upAlunosAgora} alunos agora'
        : '${repo.kyNutriAgora} nutricionistas e ${repo.kyPacientesAgora} pacientes agora';
    final sub = up
        ? '24 personais no total, 24 assinando ou em teste.'
        : '12 nutricionistas no total, 9 assinando.';
    final lista = repo.pessoasDe(proj);
    final esperam = repo.pedidos.where((p) => p.proj == proj).length;

    final titulo = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      logoDe(proj, desktop ? 40 : 17),
      SizedBox(height: desktop ? 20 : 12),
      Text(frase, style: poppins(desktop ? 36 : 22, h: 1.12)),
      const SizedBox(height: 8),
      Text(sub, style: inter(desktop ? 18 : 12, c: C.mt)),
    ]);

    final acoes = Wrap(spacing: 10, runSpacing: 10, children: [
      if (esperam > 0) Btn('Aprovar pedido', () => ir(Aba.acessos), small: !desktop),
      Btn('Enviar aviso', () {}, primary: false, small: !desktop),
    ]);

    if (desktop) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(56, 28, 56, 20),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
              flex: 5,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                titulo,
                const SizedBox(height: 36),
                Tag(up ? 'Personais' : 'Nutricionistas'),
                const SizedBox(height: 14),
                Expanded(
                    child: ListView(children: [
                  for (final p in lista) Linha(p, () => _abrir(context, p)),
                ])),
              ])),
          const SizedBox(width: 64),
          Expanded(
              flex: 4,
              child: SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 150),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    _blocos(),
                    const SizedBox(height: 36),
                    acoes,
                  ]))),
        ]),
      );
    }
    return ListView(padding: const EdgeInsets.fromLTRB(14, 18, 14, 24), children: [
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(children: [
            _seg('UpYou', up, () => ir(Aba.upyou)),
            const SizedBox(width: 8),
            _seg('keepYou', !up, () => ir(Aba.keepyou)),
          ])),
      const SizedBox(height: 20),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: titulo),
      const SizedBox(height: 18),
      for (final p in lista) Linha(p, () => _abrir(context, p), compacto: true),
      const SizedBox(height: 18),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: _blocos()),
    ]);
  }

  Widget _seg(String t, bool on, VoidCallback f) => GestureDetector(
        onTap: f,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          decoration: BoxDecoration(
              color: on ? C.p : C.s2, borderRadius: BorderRadius.circular(18)),
          child: Text(t, style: inter(12.5, w: FontWeight.w600, c: on ? Colors.white : C.mt)),
        ),
      );
}
