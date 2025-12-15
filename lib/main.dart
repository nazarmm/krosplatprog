import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class PizzaItem {
  final String name;
  final String description;
  final double price;
  final Color color;
  final IconData icon;

  PizzaItem({
    required this.name,
    required this.description,
    required this.price,
    required this.color,
    required this.icon,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Піцерія',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      home: PizzaApp(),
    );
  }
}

class PizzaApp extends StatefulWidget {
  const PizzaApp({super.key});

  @override
  _PizzaAppState createState() => _PizzaAppState();
}

class _PizzaAppState extends State<PizzaApp> {
  // Список піц (не менше 5)
  final List<PizzaItem> _pizzaItems = [
    PizzaItem(
      name: 'Маргарита',
      description: 'Томатний соус, моцарела, базилік',
      price: 159.0,
      color: Colors.red[100]!, // Виправлено: [100] замість .shade100
      icon: Icons.local_pizza,
    ),
    PizzaItem(
      name: 'Пепероні',
      description: 'Томатний соус, моцарела, пепероні',
      price: 189.0,
      color: Colors.orange[100]!,
      icon: Icons.local_fire_department,
    ),
    PizzaItem(
      name: 'Гавайська',
      description: 'Томатний соус, моцарела, курка, ананас',
      price: 199.0,
      color: Colors.yellow[100]!,
      icon: Icons.wb_sunny,
    ),
    PizzaItem(
      name: '4 Сири',
      description: 'Моцарела, горгонзола, пармезан, чеддер',
      price: 229.0,
      color: Colors.blue[100]!,
      icon: Icons.layers,
    ),
    PizzaItem(
      name: 'М\'ясна',
      description: 'Томатний соус, моцарела, бекон, салямі',
      price: 249.0,
      color: Colors.brown[100]!,
      icon: Icons.restaurant,
    ),
  ];

  final List<bool> _selectedItems = List.generate(5, (index) => false);
  
  // Контролери для полів введення (TextFormField)
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  // Логіка додавання
  void _addNewPizza() {
    if (_nameController.text.isNotEmpty &&
        _descController.text.isNotEmpty &&
        _priceController.text.isNotEmpty) {
      final newName = _nameController.text;
      
      setState(() {
        _pizzaItems.add(
          PizzaItem(
            name: newName,
            description: _descController.text,
            price: double.tryParse(_priceController.text) ?? 0.0,
            color: Colors.green[100]!,
            icon: Icons.new_releases,
          ),
        );
        _selectedItems.add(false); // Додаємо стан вибору для нової піци
        
        _nameController.clear();
        _descController.clear();
        _priceController.clear();
      });
      
      FocusScope.of(context).unfocus();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Піцу "$newName" додано!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Будь ласка, заповніть всі поля'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _toggleSelection(int index) {
    setState(() {
      _selectedItems[index] = !_selectedItems[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Піцерія "Modular2"',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // --- ВИМОГА: Додавання через TextFormField ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Додати нову піцу',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Назва піци',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.restaurant),
                      ),
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      controller: _descController,
                      decoration: InputDecoration(
                        labelText: 'Опис інгредієнтів',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.description),
                      ),
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Ціна (грн)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _addNewPizza,
                      icon: Icon(Icons.add),
                      label: Text('Додати піцу'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // --- ВИМОГА: Віджет Align ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Наше меню:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red[700]),
              ),
            ),
          ),
          
          // --- ВИМОГА: Горизонтальний ListView ---
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal, // Горизонтальний скрол
              itemCount: _pizzaItems.length,
              itemBuilder: (context, index) {
                final pizza = _pizzaItems[index];
                final isSelected = _selectedItems[index];
                
                return GestureDetector(
                  onTap: () => _toggleSelection(index),
                  child: Container(
                    width: 280, // Фіксована ширина для горизонтального елемента
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    child: Card(
                      elevation: isSelected ? 8 : 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: isSelected ? Colors.red : Colors.transparent,
                          width: isSelected ? 3 : 0,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: pizza.color,
                        ),
                        child: Column(
                          children: [
                            // --- ВИМОГА: Віджет ПЕРЕД ListTile ---
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 40,
                                child: Icon(pizza.icon, size: 40, color: Colors.red),
                              ),
                            ),
                            
                            // --- ВИМОГА: Віджет ListTile ---
                            ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.red,
                                child: Text('${index + 1}', style: TextStyle(color: Colors.white)),
                              ),
                              title: Text(
                                pizza.name,
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red[900]),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 4),
                                  Text(pizza.description),
                                  SizedBox(height: 8),
                                  Text(
                                    '${pizza.price} грн',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green[800]),
                                  ),
                                ],
                              ),
                              trailing: Icon(
                                isSelected ? Icons.check_circle : Icons.check_circle_outline,
                                color: isSelected ? Colors.red : Colors.grey,
                                size: 30,
                              ),
                            ),
                            
                            // --- ВИМОГА: Віджет ПІСЛЯ ListTile (Кнопка) ---
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: ElevatedButton.icon(
                                onPressed: () => _toggleSelection(index),
                                icon: Icon(isSelected ? Icons.remove_shopping_cart : Icons.add_shopping_cart),
                                label: Text(isSelected ? 'Видалити' : 'В кошик'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isSelected ? Colors.grey : Colors.red,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ),
                            
                            // --- ВИМОГА: Розділювач Divider ---
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Divider(
                                height: 2,
                                thickness: 2,
                                color: Colors.red[300],
                                indent: 20,
                                endIndent: 20,
                              ),
                            ),
                            
                            // Текст статусу
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                isSelected ? 'В кошику ' : 'Не вибрано',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}