import 'package:flutter/material.dart';
import 'dart:async';
import 'data.dart';
import 'ui.dart';
import 'screens/hoje.dart';
import 'screens/projeto.dart';
import 'screens/acessos.dart';
import 'screens/cobrancas.dart';
import 'screens/mais.dart';

void main() => runApp(const BeyondAdmin());

class BeyondAdmin extends StatelessWidget {
  const BeyondAdmin({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'beyond',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: C.bg,
          fontFamily: 'Inter',
          colorScheme: const ColorScheme.dark(primary: C.p, surface: C.bg),
        ),
        home: const Shell(),
      );
}

enum Aba { hoje, keepyou, upyou, acessos, cobrancas, mais }

class Shell extends StatefulWidget {
  const Shell({super.key});
  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  final repo = Repo();
  Aba aba = Aba.hoje;
  String hora = agora();
  Timer? _clock;

  @override
  void initState() {
    super.initState();
    repo.iniciar();
    _clock = Timer.periodic(const Duration(seconds: 20), (_) {
      if (mounted) setState(() => hora = agora());
    });
  }

  @override
  void dispose() {
    repo.parar();
    _clock?.cancel();
    super.dispose();
  }

  void ir(Aba a) => setState(() => aba = a);

  Widget corpo(bool desktop) {
    switch (aba) {
      case Aba.hoje:
        return HojeScreen(repo: repo, desktop: desktop, ir: ir);
      case Aba.keepyou:
        return ProjetoScreen(repo: repo, proj: Proj.ky, desktop: desktop, ir: ir);
      case Aba.upyou:
        return ProjetoScreen(repo: repo, proj: Proj.up, desktop: desktop, ir: ir);
      case Aba.acessos:
        return AcessosScreen(repo: repo, desktop: desktop);
      case Aba.cobrancas:
        return CobrancasScreen(repo: repo, desktop: desktop);
      case Aba.mais:
        return MaisScreen(repo: repo, ir: ir);
    }
  }

  @override
  Widget build(BuildContext context) {
    final desktop = MediaQuery.of(context).size.width >= 900;
    return AnimatedBuilder(
      animation: repo,
      builder: (context, _) => Scaffold(
        backgroundColor: C.bg,
        body: SafeArea(
          child: desktop ? _desktop() : _mobile(),
        ),
        bottomNavigationBar: desktop ? null : _barraMobile(),
      ),
    );
  }

  Widget _desktop() {
    final itens = <Aba, String>{
      Aba.hoje: 'Hoje',
      Aba.keepyou: 'keepYou',
      Aba.upyou: 'UpYou',
      Aba.acessos: 'Acessos',
      Aba.cobrancas: 'Cobranças',
    };
    return Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(56, 22, 56, 0),
        child: Row(children: [
          const ByLogo(28),
          const SizedBox(width: 40),
          for (final e in itens.entries)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => ir(e.key),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                    decoration: BoxDecoration(
                        color: aba == e.key ? C.s2 : Colors.transparent,
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(children: [
                      Text(e.value,
                          style: inter(15,
                              w: FontWeight.w500, c: aba == e.key ? Colors.white : C.mt)),
                      if (e.key == Aba.acessos && repo.pedidos.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(color: C.p, shape: BoxShape.circle)),
                      ]
                    ]),
                  ),
                ),
              ),
            ),
          const Spacer(),
          const Marca(Estado.online),
          const SizedBox(width: 4),
          Text('Ao vivo', style: inter(14, w: FontWeight.w500, c: C.pl)),
          const SizedBox(width: 10),
          Text(hora, style: inter(14, c: C.mt)),
          const SizedBox(width: 20),
          Container(
              width: 38,
              height: 38,
              alignment: Alignment.center,
              decoration: const BoxDecoration(color: C.s2, shape: BoxShape.circle),
              child: Text('V', style: poppins(14))),
        ]),
      ),
      Expanded(child: corpo(true)),
    ]);
  }

  Widget _mobile() => corpo(false);

  Widget _barraMobile() {
    final ativo = aba == Aba.hoje
        ? 0
        : (aba == Aba.keepyou || aba == Aba.upyou)
            ? 1
            : aba == Aba.acessos
                ? 2
                : 3;
    final nomes = ['Hoje', 'Projetos', 'Acessos', 'Mais'];
    final destinos = [Aba.hoje, Aba.upyou, Aba.acessos, Aba.mais];
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        height: 58,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(color: C.s2, borderRadius: BorderRadius.circular(29)),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          for (int i = 0; i < 4; i++)
            GestureDetector(
              onTap: () => ir(destinos[i]),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                    color: ativo == i ? C.p : Colors.transparent,
                    borderRadius: BorderRadius.circular(22)),
                child: Text(nomes[i],
                    style: inter(13,
                        w: ativo == i ? FontWeight.w600 : FontWeight.w500,
                        c: ativo == i ? Colors.white : C.mt)),
              ),
            ),
        ]),
      ),
    );
  }
}
