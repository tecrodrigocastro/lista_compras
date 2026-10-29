import 'package:flutter/material.dart';

void main() => runApp(const ComprasApp());

// 1) O app: configura o tema e aponta para a primeira tela.
class ComprasApp extends StatelessWidget {
  const ComprasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xFFD42A16)),
      home: const ComprasPage(),
    );
  }
}

// 2) O modelo: um item da lista.
class Item {
  Item(this.nome);

  final String nome;
  bool comprado = false;
}

// 3) A tela: StatefulWidget, porque a lista muda com o tempo.
class ComprasPage extends StatefulWidget {
  const ComprasPage({super.key});

  @override
  State<ComprasPage> createState() => _ComprasPageState();
}

class _ComprasPageState extends State<ComprasPage> {
  final List<Item> itens = [Item('Arroz'), Item('Feijão'), Item('Café')];
  final TextEditingController controller = TextEditingController();

  int get pendentes => itens.where((i) => !i.comprado).length;

  void adicionar() {
    final nome = controller.text.trim();
    if (nome.isEmpty) return;
    setState(() => itens.add(Item(nome)));
    controller.clear();
  }

  void alternar(Item item) {
    setState(() => item.comprado = !item.comprado);
  }

  void remover(Item item) {
    setState(() => itens.remove(item));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Compras')),
      body: Column(
        children: [
          // Campo para adicionar um novo item
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(hintText: 'Novo item', border: OutlineInputBorder()),
                    onSubmitted: (_) => adicionar(),
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton(onPressed: adicionar, child: const Text('Adicionar')),
              ],
            ),
          ),

          // A lista de itens
          Expanded(
            child: itens.isEmpty
                ? const Center(child: Text('Lista vazia. Adicione um item.'))
                : ListView.builder(
                    itemCount: itens.length,
                    itemBuilder: (context, i) {
                      final item = itens[i];
                      return Dismissible(
                        key: ObjectKey(item),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) => remover(item),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 24),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: CheckboxListTile(
                          title: Text(item.nome, style: TextStyle(decoration: item.comprado ? TextDecoration.lineThrough : null)),
                          value: item.comprado,
                          onChanged: (_) => alternar(item),
                        ),
                      );
                    },
                  ),
          ),

          // Rodapé com o contador
          Padding(padding: const EdgeInsets.all(16), child: Text('$pendentes pendentes')),
        ],
      ),
    );
  }
}
