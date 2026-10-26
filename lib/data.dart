import 'dart:async';
import 'package:flutter/foundation.dart';

enum Proj { up, ky }

enum Estado { online, espera, offline }

class Pessoa {
  final String nome;
  final String detalhe;
  final Proj proj;
  Estado estado;
  String quando;
  final List<String> linhas;
  Pessoa(this.nome, this.detalhe, this.proj, this.estado, this.quando,
      [this.linhas = const []]);
}

class Pedido {
  final String nome;
  final String sub;
  final Proj proj;
  final String quando;
  final List<String> linhas;
  Pedido(this.nome, this.sub, this.proj, this.quando, this.linhas);
}

class Cobranca {
  final String nome;
  String sub;
  final int valor;
  final Proj proj;
  bool atrasada;
  bool recebida;
  Cobranca(this.nome, this.sub, this.valor, this.proj,
      {this.atrasada = false, this.recebida = false});
}

class Evento {
  final String hora;
  final Proj proj;
  final String texto;
  final String? sub;
  Evento(this.hora, this.proj, this.texto, [this.sub]);
}

String agora() {
  final n = DateTime.now();
  String d(int v) => v.toString().padLeft(2, '0');
  return '${d(n.hour)}:${d(n.minute)}';
}

String reais(int v) => 'R\$ $v';

String milhar(int v) {
  final s = v.toString();
  final b = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
    b.write(s[i]);
  }
  return b.toString();
}

/// Fonte de dados. Hoje usa dados de exemplo e simula eventos ao vivo.
/// Para ligar ao Supabase, troque o conteudo desta classe mantendo os
/// mesmos metodos e listas (ver LEIA-ME.md).
class Repo extends ChangeNotifier {
  Timer? _t;
  int _i = 0;

  int upPersonaisAgora = 9;
  int upAlunosAgora = 33;
  int kyNutriAgora = 6;
  int kyPacientesAgora = 21;
  int upAulasHoje = 96;
  int upAvisos = 188;
  int kyConsultas = 38;
  int kyRespostasIa = 51;

  final bool iaLenta = true;

  final List<Pessoa> pessoas = [
    Pessoa('Carlos Lima', 'Pro, 14 alunos', Proj.up, Estado.online,
        'No app há 2 min', [
      'Plano Pro, assinando desde setembro.',
      '14 alunos, 61 aulas marcadas este mês.',
      'Último Pix há 4 dias, em dia até 22 de novembro.',
      'Indicou 2 personais, um deles está em teste.'
    ]),
    Pessoa('Mariana Teixeira', 'Gestão, 9 alunos', Proj.up, Estado.online,
        'No app há 5 min', [
      'Plano Gestão, assinando desde outubro.',
      '9 alunos, 38 aulas marcadas este mês.',
      'Último Pix há 12 dias, em dia até 14 de novembro.'
    ]),
    Pessoa('Diego Farias', 'Teste, termina em 6 de novembro', Proj.up,
        Estado.online, 'Começou há 3 dias', [
      'Em teste de 14 dias, termina em 6 de novembro.',
      '3 alunos cadastrados.',
      'Ainda não escolheu um plano.'
    ]),
    Pessoa('Clara Dias', 'Essencial, Pix atrasado', Proj.up, Estado.espera,
        'Pausa às 08:00', [
      'Plano Essencial.',
      'Pix atrasado há 3 dias. O acesso pausa amanhã às 08:00.',
      'Abriu o app hoje cedo.'
    ]),
    Pessoa('Bruno Alves', 'Essencial, 6 alunos', Proj.up, Estado.offline,
        'No app ontem, 21:05', [
      'Plano Essencial.',
      '6 alunos, 22 aulas marcadas este mês.',
      'Pagou por Pix hoje.'
    ]),
    Pessoa('Dra. Paula Reis', 'Pro, assinando desde agosto', Proj.ky,
        Estado.online, 'No app há 3 min', [
      'Plano Pro, assinando desde agosto.',
      '26 pacientes, 12 consultas esta semana.',
      'Aprovou 3 respostas da IA hoje.'
    ]),
    Pessoa('Dra. Lívia Torres', 'Inicial, 11 de 15 pacientes', Proj.ky,
        Estado.online, 'No app há 1 min', [
      'Plano Inicial, 11 de 15 pacientes.',
      'Montou um plano alimentar com a IA hoje.'
    ]),
    Pessoa('Dr. Heitor Brandão', 'Teste, termina em 9 de novembro', Proj.ky,
        Estado.online, 'Começou há 8 min', [
      'Em teste de 14 dias, termina em 9 de novembro.',
      'Está montando os primeiros pacientes.'
    ]),
    Pessoa('Dr. Marcelo Antunes', 'Inicial, 14 de 15 pacientes', Proj.ky,
        Estado.offline, 'No app ontem, 18:40', [
      'Plano Inicial, 14 de 15 pacientes.',
      'Perto do limite do plano. Vale sugerir o Pro.'
    ]),
    Pessoa('Dra. Júlia Fontes', 'Pro, assinando desde setembro', Proj.ky,
        Estado.offline, 'No app hoje, 09:12', [
      'Plano Pro, assinando desde setembro.',
      'Próxima cobrança na quinta.'
    ]),
  ];

  final List<Pedido> pedidos = [
    Pedido('Rafael Moura', 'Personal em Campinas, indicado por Carlos Lima',
        Proj.up, 'há 12 min', [
      'Personal trainer em Campinas.',
      'CREF 123456-G/SP.',
      'Pediu há 12 minutos, indicado por Carlos Lima.'
    ]),
    Pedido('Dra. Camila Rocha', 'Nutricionista em Curitiba, veio pelo Instagram',
        Proj.ky, 'há 1 hora', [
      'Nutricionista em Curitiba.',
      'CRN 8 12345.',
      'Pediu há 1 hora, veio pelo Instagram.'
    ]),
    Pedido('Thiago Pires', 'Personal em Santos, veio pelo site', Proj.up,
        'há 3 horas', [
      'Personal trainer em Santos.',
      'CREF 654321-G/SP.',
      'Pediu há 3 horas, veio pelo site.'
    ]),
  ];

  final List<Cobranca> cobrancas = [
    Cobranca('Clara Dias', 'Pix atrasado há 3 dias. Acesso pausa amanhã às 08:00',
        25, Proj.up,
        atrasada: true),
    Cobranca('Dr. Marcelo Antunes', 'Vence amanhã', 79, Proj.ky),
    Cobranca('Dra. Júlia Fontes', 'Vence na quinta', 149, Proj.ky),
    Cobranca('Bruno Alves', 'Pix há 4 min', 25, Proj.up, recebida: true),
    Cobranca('Fernanda Souza', 'Cartão há 2 horas', 25, Proj.up, recebida: true),
  ];

  final List<Evento> eventos = [
    Evento('14:32', Proj.up, 'Pix de R\$ 25 recebido de Bruno Alves.',
        'Assinatura renovada por mais um mês.'),
    Evento('14:31', Proj.ky, 'Dra. Paula Reis aprovou 3 respostas escritas pela IA.'),
    Evento('14:29', Proj.up, 'Carlos Lima cadastrou um aluno novo com convite.'),
    Evento('14:27', Proj.up, '12 avisos de aula enviados para amanhã.'),
    Evento('14:24', Proj.ky, 'Dr. Heitor Brandão começou o teste de 14 dias.'),
    Evento('14:20', Proj.up, 'Aula de Fernanda Souza passou para "dada".'),
    Evento('14:18', Proj.ky, 'Dra. Lívia Torres montou um plano com a IA.'),
    Evento('14:11', Proj.up, 'Rafael Moura pediu acesso e espera você.'),
    Evento('14:05', Proj.ky, 'A IA respondeu mais devagar que o normal.'),
  ];

  static final List<List<Object>> _pool = [
    [Proj.up, 'Mariana Teixeira marcou 3 aulas novas.'],
    [Proj.ky, 'Dra. Paula Reis cadastrou um paciente novo.'],
    [Proj.up, '8 alunos confirmaram presença para amanhã.'],
    [Proj.ky, 'Dra. Lívia Torres aprovou uma resposta da IA.'],
    [Proj.up, 'Carlos Lima remarcou uma aula a pedido do aluno.'],
    [Proj.ky, 'Dr. Heitor Brandão abriu o plano alimentar de um paciente.'],
    [Proj.up, 'Diego Farias cadastrou o terceiro aluno do teste.'],
  ];

  void iniciar() {
    _t ??= Timer.periodic(const Duration(seconds: 7), (_) {
      final p = _pool[_i % _pool.length];
      _i++;
      _add(Evento(agora(), p[0] as Proj, p[1] as String));
      if (_i % 3 == 0) upAlunosAgora += 1;
      if (_i % 4 == 0 && upAlunosAgora > 30) upAlunosAgora -= 1;
      notifyListeners();
    });
  }

  void parar() {
    _t?.cancel();
    _t = null;
  }

  void _add(Evento e) {
    eventos.insert(0, e);
    if (eventos.length > 30) eventos.removeLast();
  }

  List<Pessoa> pessoasDe(Proj p) => pessoas.where((x) => x.proj == p).toList();

  int get atrasadas => cobrancas.where((c) => c.atrasada && !c.recebida).length;

  int get pendencias => pedidos.length + atrasadas;

  int get recebidoUp => 640;
  int get recebidoKy => 851;
  int get recebidoTotal => recebidoUp + recebidoKy;

  void aprovar(Pedido p) {
    pedidos.remove(p);
    final pos = pessoas.indexWhere((x) => x.proj == p.proj);
    pessoas.insert(
        pos < 0 ? 0 : pos,
        Pessoa(p.nome, 'Teste de 14 dias começando agora', p.proj,
            Estado.online, 'Começou agora', [
          'Teste de 14 dias começando agora.',
          'O código de acesso foi enviado para o app dele.'
        ]));
    _add(Evento(agora(), p.proj,
        '${p.nome} foi aprovado(a). O código de acesso foi enviado.'));
    notifyListeners();
  }

  void recusar(Pedido p) {
    pedidos.remove(p);
    _add(Evento(agora(), p.proj, 'Pedido de ${p.nome} foi recusado.'));
    notifyListeners();
  }

  void lembrar(Cobranca c) {
    _add(Evento(agora(), c.proj, 'Lembrete de pagamento enviado para ${c.nome}.'));
    c.atrasada = false;
    c.sub = 'Lembrete enviado agora';
    notifyListeners();
  }

  void pausar(Pessoa p) {
    p.estado = Estado.offline;
    p.quando = 'Acesso pausado';
    _add(Evento(agora(), p.proj, 'Acesso de ${p.nome} foi pausado.'));
    notifyListeners();
  }

  void avisar(Pessoa p) {
    _add(Evento(agora(), p.proj, 'Aviso enviado para ${p.nome}.'));
    notifyListeners();
  }
}
