import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import '../components/danh_sach.dart';
import '../models/khach_hang.dart';
import 'editCustomer.dart';

class Thongke extends StatefulWidget {
  const Thongke({super.key});

  @override
  State<Thongke> createState() => _ThongkeState();
}

class _ThongkeState extends State<Thongke> {
  final ProductList _list = ProductList();
  final controller = AutoScrollController();
  final GlobalKey _scaffoldKey = GlobalKey();
  bool _showScrollUpButton = false;
  @override
  void initState() {
    super.initState();
    _loadProducts();
    controller.addListener(() {
      if (controller.offset >= 10.0) {
        setState(() {
          _showScrollUpButton = true;
        });
      } else {
        setState(() {
          _showScrollUpButton = false;
        });
      }
    });
  }

  double get totalRevenue {
    double sum = 0;
    for (final product in _list.products) {
      if (product.status == true) {
        if (product.isVip == false) {
          sum += product.thanhTien;
        } else {
          sum += product.finalValue;
        }
      }
    }
    return sum;
  }

  double get totalcustomer {
    double sum = 0;

    sum += _list.products.length;

    return sum;
  }

  double get getTotalCustomerTT {
    double sum = 0;

    for (int i = _list.products.length - 1; i >= 0; i--) {
      // sum += _list.products[i].id;
      if (_list.products[i].status == true) {
        sum++;
      }
    }

    return sum;
  }

  double get getTotalCustomerCTT {
    double sum = 0;

    for (int i = _list.products.length - 1; i >= 0; i--) {
      // sum += _list.products[i].id;
      if (_list.products[i].status == false) {
        sum++;
      }
    }

    return sum;
  }

  Future<void> _loadProducts() async {
    await _list.load();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  height: 28.0,
                ),
                Row(
                  children: [
                    const Text('Tổng số khách hàng :',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const Spacer(
                      flex: 1,
                    ),
                    Text(Util.formatWithSeparator(totalcustomer)),
                  ],
                ),
                const SizedBox(
                  height: 12.0,
                ),
                Row(
                  children: [
                    const Text('Tổng số khách hàng đã thanh toán :',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const Spacer(
                      flex: 1,
                    ),
                    Text(Util.formatWithSeparator(getTotalCustomerTT)),
                  ],
                ),
                const SizedBox(
                  height: 12.0,
                ),
                Row(
                  children: [
                    const Text('Tổng số khách hàng chưa thanh toán :',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const Spacer(
                      flex: 1,
                    ),
                    Text(Util.formatWithSeparator(getTotalCustomerCTT)),
                  ],
                ),
                const SizedBox(
                  height: 12.0,
                ),
                Row(
                  children: [
                    const Text('Tổng số doanh thu :',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const Spacer(
                      flex: 1,
                    ),
                    Text(
                      Util.formatWithSeparator(totalRevenue),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 28.0,
                ),
                Align(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.36, color: Colors.red),
                    ),
                    height: 1,
                    width: constraints.maxWidth,
                  ),
                ),
                ListView.separated(
                  controller: controller,
                  physics: const NeverScrollableScrollPhysics(), //khoa cuon
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: _list.products.length,

                  itemBuilder: (BuildContext context, int index) {
                    // Truy cập sản phẩm tại vị trí index trong danh sách
                    DataModel product = _list.products[index];

                    // Trả về widget danh sách tương ứng
                    return AutoScrollTag(
                      index: index,
                      controller: controller,
                      key: ValueKey(index),
                      child: Danhsach(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                // title: Text('Error'),
                                content: const Text(
                                    'Bạn có muốn xóa khách hàng này không?'),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Không'),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  TextButton(
                                    child: const Text('Có'),
                                    onPressed: () => setState(() {
                                      _list.deleteProduct(product.id);

                                      Navigator.of(context).pop();
                                    }),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        onPressed1: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                // title: Text('Error'),
                                content:
                                    const Text('Bạn có muốn chỉnh sửa không?'),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Không'),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  TextButton(
                                      child: const Text('Có'),
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EditCustomerPage(
                                                      data: product,
                                                    )));
                                        setState(() {});
                                      }),
                                ],
                              );
                            },
                          );
                        },
                        data: product,
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16.8),
                ),
              ],
            ),
          ),
        );
      }),
      floatingActionButton: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _showScrollUpButton
            ? GestureDetector(
                onTap: () {
                  controller.scrollToIndex(0);
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                  child: Icon(
                    Icons.arrow_upward,
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(16),
                ),
              )
            : SizedBox(
                width: 0,
                height: 0,
              ),
      ),
    );
  }
}
