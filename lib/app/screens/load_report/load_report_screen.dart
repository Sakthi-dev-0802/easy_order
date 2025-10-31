import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class LoadReportPage extends StatefulWidget {
  final String lineId;
  final String lineName;

  const LoadReportPage({
    super.key,
    required this.lineId,
    required this.lineName,
  });

  @override
  State<LoadReportPage> createState() => _LoadReportPageState();
}

class _LoadReportPageState extends State<LoadReportPage> {
  final List<String> clients = [
    "Client A",
    "Client B",
    "Client C",
    "Client D",
    "Client E",
    "Client F",
    "Client G",
    "Client H",
    "Client I",
    "Client J",
    "Client K",
    "Client L",
    "Client M",
    "Client N",
    "Client O",
  ];

  final List<String> items = [
    "Apples",
    "Bananas",
    "Oranges",
    "Grapes",
    "Mangoes",
    "Pineapple",
    "Papaya",
    "Guava",
    "Watermelon",
    "Kiwi",
    "Peach",
    "Plum",
    "Strawberry",
    "Blueberry",
    "Raspberry",
    "Lemon",
    "Lime",
    "Coconut",
    "Pomegranate",
    "Cherry",
    "Avocado",
    "Fig",
    "Date",
    "Pear",
    "Jackfruit",
    "Dragon Fruit",
    "Lychee",
    "Tangerine",
    "Custard Apple",
    "Starfruit",
  ];

  late List<List<Map<String, dynamic>>> orders;

  final ScrollController _verticalBodyController = ScrollController();
  final ScrollController _horizontalBodyController = ScrollController();
  final ScrollController _verticalItemController = ScrollController();
  final ScrollController _horizontalHeaderController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Sync vertical scroll between items column and body
    _verticalBodyController.addListener(() {
      _verticalItemController.jumpTo(_verticalBodyController.offset);
    });

    // Sync horizontal scroll between header and body
    _horizontalBodyController.addListener(() {
      _horizontalHeaderController.jumpTo(_horizontalBodyController.offset);
    });

    // Create order data
    orders = List.generate(
      items.length,
      (i) => List.generate(
        clients.length,
        (j) => {
          'packType': ['Box', 'Bag', 'Crate', 'Carton'][((i + j) % 4)],
          'count': (i * j + j + 1) % 10 + 1,
          'loaded': false,
        },
      ),
    );
  }

  void toggleLoaded(int i, int j) {
    setState(() {
      orders[i][j]['loaded'] = !orders[i][j]['loaded'];
    });
  }

  void editOrder(int i, int j) async {
    final packController =
        TextEditingController(text: orders[i][j]['packType']);
    final countController =
        TextEditingController(text: orders[i][j]['count'].toString());

    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("Edit Order for ${items[i]} - ${clients[j]}"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: packController,
                decoration: const InputDecoration(labelText: "Pack Type"),
              ),
              TextField(
                controller: countController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Count"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  orders[i][j]['packType'] = packController.text;
                  orders[i][j]['count'] =
                      int.tryParse(countController.text) ?? 0;
                });
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _verticalBodyController.dispose();
    _horizontalBodyController.dispose();
    _verticalItemController.dispose();
    _horizontalHeaderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double cellWidth = 120;
    const double cellHeight = 60;
    final borderColor = Colors.grey.shade700;

    return Scaffold(
      appBar: AppBar(title: const Text("Market Order Loading Table")),
      body: Column(
        children: [
          // Sticky top header row
          Row(
            children: [
              Container(
                width: cellWidth,
                height: cellHeight,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  border: Border.all(color: borderColor, width: 1.2),
                ),
                child: const Text(
                  "Items",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: _horizontalHeaderController,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: clients.map((client) {
                      return Container(
                        width: cellWidth,
                        height: cellHeight,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          border: Border.all(color: borderColor, width: 1.2),
                        ),
                        child: Text(
                          client,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),

          // Scrollable body with sticky first column
          Expanded(
            child: Row(
              children: [
                // Sticky first column (items)
                SingleChildScrollView(
                  controller: _verticalItemController,
                  child: Column(
                    children: items.map((item) {
                      return Container(
                        width: cellWidth,
                        height: cellHeight,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          border: Border.all(color: borderColor, width: 1.2),
                        ),
                        child: Text(
                          item,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                // Scrollable order grid
                Expanded(
                  child: SingleChildScrollView(
                    controller: _horizontalBodyController,
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      controller: _verticalBodyController,
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: List.generate(items.length, (i) {
                          return Row(
                            children: List.generate(clients.length, (j) {
                              final order = orders[i][j];
                              return GestureDetector(
                                onTap: () => toggleLoaded(i, j),
                                onLongPress: () => editOrder(i, j),
                                child: Container(
                                  width: cellWidth,
                                  height: cellHeight,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: order['loaded']
                                        ? Colors.green.shade300
                                        : Colors.white,
                                    border: Border.all(
                                        color: borderColor, width: 1),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(order['packType']),
                                      const SizedBox(height: 4),
                                      Text("${order['count']} packs"),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
