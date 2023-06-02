import 'package:cuoi_ki_flutter/components/custom_button.dart';
import 'package:cuoi_ki_flutter/components/custom_text_field.dart';
import 'package:cuoi_ki_flutter/components/danh_sach.dart';
import 'package:cuoi_ki_flutter/models/khach_hang.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  bool isChecked = false;
  String thanhtien = '';
  String formattedDate =
      DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now());

  final ProductList _list = ProductList();

  bool isPaid = false;
  bool canEditPaid = true;
  int _nextId = 1;
  @override
  void initState() {
    super.initState();

    _loadProducts();
  }

  Future<void> _loadProducts() async {
    await _list.load();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  void pay(DataModel customer) {
    setState(() {
      customer.status = true;
    });
  }

  void _showthanhtoan() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Bạn có muốn thanh toán không ?'),
          // content: Text('Total: \$${total.toStringAsFixed(2)}'),
          actions: <Widget>[
            TextButton(
              child: const Text('Không'),
              onPressed: () async {
                String name = nameController.text.trim();
                double quantity = double.parse(quantityController.text.trim());
                double price = double.parse(priceController.text.trim());
                DataModel product = DataModel(
                    id: _nextId++,
                    name: name,
                    quantity: quantity,
                    price: price,
                    status: isPaid,
                    isVip: isChecked,
                    dateTime: formattedDate);

                if (isChecked) {
                  thanhtien =
                      Util.formatWithSeparator(product.finalValue).toString();
                } else {
                  thanhtien =
                      Util.formatWithSeparator(product.thanhTien).toString();
                }
                _list.addProduct(name, price, quantity, false, isChecked);
                // _shared.save(_data);
                // In ra danh sách sản phẩm để kiểm tra
                List<DataModel> products = _list.products;
                for (DataModel product in products) {
                  print(
                      ' ${product.name} ,${product.price},${product.quantity}, ${product.thanhTien}');
                }

                nameController.clear();
                quantityController.clear();
                priceController.clear();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
                child: const Text('Có'),
                onPressed: () async {
                  String name = nameController.text.trim();
                  double quantity =
                      double.parse(quantityController.text.trim());
                  double price = double.parse(priceController.text.trim());
                  DataModel product = DataModel(
                      id: _nextId++,
                      name: name,
                      quantity: quantity,
                      price: price,
                      status: isPaid,
                      isVip: isChecked,
                      dateTime: formattedDate);

                  if (isChecked) {
                    thanhtien =
                        Util.formatWithSeparator(product.finalValue).toString();
                  } else {
                    thanhtien =
                        Util.formatWithSeparator(product.thanhTien).toString();
                  }
                  _list.addProduct(name, price, quantity, true, isChecked);
                  // _shared.save(_data);
                  // In ra danh sách sản phẩm để kiểm tra
                  List<DataModel> products = _list.products;
                  for (DataModel product in products) {
                    print(
                        ' ${product.name} ,${product.price},${product.quantity}, ${product.thanhTien}');
                  }

                  nameController.clear();
                  quantityController.clear();
                  priceController.clear();
                  Navigator.of(context).pop();
                }),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.red;
    }

    return Scaffold(
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 40.0),
              CustomTextField(
                controller: nameController,
                hintText: 'Tên khách hàng',
                lableText: 'Tên khách hàng',
              ),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  // const Spacer(flex: 1),
                  Expanded(
                    flex: 2,
                    child: CustomTextField(
                      controller: quantityController,
                      hintText: 'Số lượng sách',
                      lableText: 'Số lượng sách ',
                    ),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  Expanded(
                    flex: 2,
                    child: CustomTextField(
                      controller: priceController,
                      hintText: 'Price / 1 đơn vị',
                      lableText: 'Price / 1 đơn vị ',
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 26.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Checkbox(
                    checkColor: Colors.white,
                    fillColor: MaterialStateProperty.resolveWith(getColor),
                    value: isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        String name = nameController.text.trim();
                        double quantity =
                            double.parse(quantityController.text.trim());
                        double price =
                            double.parse(priceController.text.trim());

                        DataModel product = DataModel(
                            id: _nextId++,
                            name: name,
                            quantity: quantity,
                            price: price,
                            status: isPaid,
                            isVip: isChecked,
                            dateTime: formattedDate);
                        if (isChecked = value!) {
                          thanhtien =
                              Util.formatWithSeparator(product.finalValue)
                                  .toString();
                        } else {
                          thanhtien =
                              Util.formatWithSeparator(product.thanhTien)
                                  .toString();
                        }
                        // isChecked = true;
                      });
                    },
                  ),
                  const Text('Khách hàng vip (discount 10 %)'),
                ],
              ),
              const SizedBox(
                height: 26.0,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: CustomButton(
                        onPressed: () {
                          String name = nameController.text.trim();
                          double quantity =
                              double.parse(quantityController.text.trim());
                          double price =
                              double.parse(priceController.text.trim());
                          DataModel product = DataModel(
                              id: _nextId++,
                              name: name,
                              quantity: quantity,
                              price: price,
                              status: isPaid,
                              isVip: isChecked,
                              dateTime: formattedDate);

                          if (isChecked) {
                            thanhtien =
                                Util.formatWithSeparator(product.finalValue)
                                    .toString();
                          } else {
                            thanhtien =
                                Util.formatWithSeparator(product.thanhTien)
                                    .toString();
                          }

                          setState(() {
                            // pay(product);
                          });
                        },
                        text: 'Thành tiền'),
                  ),
                  const SizedBox(
                    width: 22.0,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2.0),
                        color: Colors.grey[300],
                      ),
                      height: 42.0,
                      child: Center(
                        child: Text(
                          '${thanhtien}VND',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 26.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                      onPressed: _showthanhtoan, text: 'Lưu thông tin'),
                ],
              ),
              const SizedBox(
                height: 28.0,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1.2, color: Colors.red),
                ),
                height: 1,
                width: constraints.maxWidth,
              ),
              ListView.builder(
                reverse: true,
                physics: const NeverScrollableScrollPhysics(), //khoa cuon
                shrinkWrap: true,
                padding: EdgeInsets.zero,

                itemCount: _list.products.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text(_list.products[index].name),
                        subtitle: Text(
                          'id: ${_list.products[index].id},Price: ${_list.products[index].price}, Quantity: ${_list.products[index].quantity},${_list.products[index].isVip ? ' VIP' : ''}',
                        ),
                        trailing: _list.products[index].status
                            ? Text('Đã thanh toán')
                            : Text('Chưa thanh toán'),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ));
      }),
    );
  }
}
