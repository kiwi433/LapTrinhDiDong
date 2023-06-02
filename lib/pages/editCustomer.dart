import 'package:flutter/material.dart';

import '../components/danh_sach.dart';
import '../models/khach_hang.dart';

class EditCustomerPage extends StatefulWidget {
  final DataModel data;
  const EditCustomerPage({super.key, required this.data});
  @override
  State<EditCustomerPage> createState() => _EditCustomerPageState();
}

class _EditCustomerPageState extends State<EditCustomerPage> {
  final ProductList _list = ProductList();
  bool _isPaid = false;
  bool _isChecked1 = false;
  bool _isChecked2 = false;
  @override
  void initState() {
    super.initState();

    if (widget.data.status == false) {
      _isChecked1 = true;
    } else {
      _isChecked2 = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 140.0, left: 20.0, right: 20.0),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'CHỈNH SỬA',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 198, 40, 40),
                      fontSize: 25.0),
                ),
              ],
            ),
            const SizedBox(
              height: 35.0,
            ),
            Row(
              children: [
                Row(
                  children: [
                    Text('Tên khách hàng:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(' ${widget.data.name}')
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 12.0,
            ),
            Row(
              children: [
                Text('Tổng tiền: ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                    '${Util.formatWithSeparator(widget.data.isVip ? widget.data.finalValue : widget.data.thanhTien)}'),
              ],
            ),
            const SizedBox(
              height: 12.0,
            ),
            Row(
              children: [
                Text('Số lượng: ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('${Util.formatWithSeparator(widget.data.quantity)}')
              ],
            ),
            const SizedBox(
              height: 12.0,
            ),
            Row(
              children: [
                Text('Thời gian đặt: ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('${widget.data.dateTime}')
              ],
            ),
            Row(
              children: [
                Text('Trạng thái:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Checkbox(
                      value: _isChecked1,
                      onChanged: (bool? value) {
                        setState(() {
                          _isChecked1 = value!;
                          _isChecked2 = !_isChecked1;
                          _isPaid = !_isChecked1;
                        });
                      },
                    ),
                    const Text('Chưa Thanh toán'),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 78.0),
              child: Row(
                children: [
                  Checkbox(
                    value: _isChecked2,
                    onChanged: (bool? value) {
                      setState(() {
                        _isChecked2 = value!;
                        _isChecked1 = !_isChecked2;
                        _isPaid = !_isChecked2;
                      });
                    },
                  ),
                  const Text('Đã Thanh toán'),
                ],
              ),
            ),
            SizedBox(
              height: 26.0,
            ),
            Row(
              children: [
                Spacer(
                  flex: 1,
                ),
                Row(
                  children: [
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.grey[300])),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Hủy',
                          style: TextStyle(color: Colors.black),
                        )),
                  ],
                ),
                const SizedBox(
                  width: 26.0,
                ),
                Row(
                  children: [
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.red[800])),
                        onPressed: () {
                          _list.editProduct(
                              widget.data.id, widget.data.status == _isPaid);
                          setState(() {
                            _list.load();
                          });
                          print('Trạng thái: ${_isPaid},id :${widget.data.id}');
                          Navigator.pop(context);
                        },
                        child: const Text('Lưu Thay đổi')),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
