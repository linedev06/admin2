import 'package:flutter/material.dart';
import '../data.dart';
import '../ui.dart';
import '../main.dart';

class MaisScreen extends StatelessWidget {
  final Repo repo;
  final void Function(Aba) ir;
  const MaisScreen({super.key, required this.repo, required this.ir});

  Widget _item(BuildContext context, String t, String s, VoidCallback f) => GestureDetector(
        onTap: f,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(t, style: poppins(15)),
            Text(s, style: inter(12, c: C.mt)),
          ]),
        ),
      );

  void _breve(BuildContext context) => ScaffoldMessenger.of(context)
      .showSnackBar(const SnackBar(content: Text('Em breve.'), duration: Duration(seconds: 1)));

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.fromLTRB(22, 22, 22, 24), children: [
      Text('Mais', style: poppins(26)),
      const SizedBox(height: 22),
      const Tag('Sistema'),
      const SizedBox(height: 10),
      const Wrap(runSpacing: 6, children: [
        StatusLinha('Banco de dados'),
        SizedBox(width: double.infinity),
        StatusLinha('Pagamentos'),
        SizedBox(width: double.infinity),
        StatusLinha('Avisos no celular'),
        SizedBox(width: double.infinity),
        StatusLinha('IA mais lenta que o normal', aviso: true),
      ]),
      const SizedBox(height: 24),
      _item(context, 'Cobranças', '${repo.cobrancas.where((c) => !c.recebida).length} aguardando',
          () => ir(Aba.cobrancas)),
      _item(context, 'Enviar aviso', 'Todos os projetos', () => _breve(context)),
      _item(context, 'Relatório do mês', 'PDF', () => _breve(context)),
      _item(context, 'Segurança', 'Autenticador ativo', () => _breve(context)),
      _item(context, 'Sair', '', () => _breve(context)),
    ]);
  }
}
