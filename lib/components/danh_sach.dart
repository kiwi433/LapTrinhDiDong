import '../models/khach_hang.dart';
import 'package:flutter/material.dart';

class Danhsach extends StatelessWidget {
  final DataModel data;
  // final bool status = false;
  final VoidCallback? onPressed;
  final VoidCallback? onPressed1;
  const Danhsach({
    super.key,
    required this.data,
    this.onPressed,
    this.onPressed1,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        children: [
          const SizedBox(
            height: 12.0,
          ),
          Row(
            children: [
              IntrinsicWidth(
                child: Text('Khách hàng: ${data.name}'),
              ),
              const Spacer(
                flex: 1,
              ),
              Expanded(
                flex: 1,
                child: data.isVip
                    // ignore: dead_code
                    ? const Row(children: [
                        Text(
                          'VIP',
                          style: TextStyle(
                              color: Color.fromARGB(255, 198, 40, 40)),
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.red,
                        )
                      ])
                    : const Text(''),
              ),
            ],
          ),
          const SizedBox(
            height: 12.0,
          ),
          Row(
            children: [
              Text(
                  'Trạng thái: ${data.status ? 'Đã thanh toán' : 'Chưa thanh toán'}'),
            ],
          ),
          const SizedBox(
            height: 12.0,
          ),
          Row(
            children: [
              Text('Ngay: ${data.dateTime}'),
            ],
          ),
          const SizedBox(
            height: 12.0,
          ),
          Row(
            children: [
              const SizedBox(
                height: 12.0,
              ),
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Text(
                        'Quantity: ${(data.quantity).toString().replaceAll('.0', '')}'),
                  ],
                ),
              ),
              const Spacer(
                flex: 1,
              ),
              IntrinsicWidth(
                child: Row(
                  children: [
                    Text('Price: ${Util.formatWithSeparator(data.price)} vnđ'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 12.0,
          ),
          Row(
            children: [
              const SizedBox(
                height: 12.0,
              ),
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                  ),
                  height: 1,
                  width: constraints.minWidth,
                ),
              ),
              const SizedBox(
                width: 12.0,
              ),
              IntrinsicWidth(
                child: Center(
                  child: Text(
                    // ignore: dead_code
                    'Total Price: ${Util.formatWithSeparator(data.isVip ? data.finalValue : data.thanhTien)} vnđ',
                  ),
                ),
              ),
              const SizedBox(
                width: 12.0,
              ),
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                  ),
                  height: 1,
                  width: constraints.minWidth,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 12.0,
          ),
          const SizedBox(
            height: 12.0,
          ),
          Container(
              child: !data.status
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: onPressed,
                          child: const Padding(
                            padding: EdgeInsets.all(6.0),
                            child: CircleAvatar(
                              backgroundColor: Colors.orange,
                              radius: 12.0,
                              child: Icon(Icons.delete,
                                  size: 14.0, color: Colors.white),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: onPressed1,
                          child: const Padding(
                            padding: EdgeInsets.all(6.0),
                            child: CircleAvatar(
                              backgroundColor: Colors.green,
                              radius: 12.0,
                              child: Icon(Icons.edit_square,
                                  size: 14.0, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    )
                  : null)
        ],
      );
    });
  }
}

class Util {
  static String formatWithSeparator(double number) {
    String numStr = number.toString().replaceAll('.0', '');
    String result = '';
    int counter = 0;
    for (int i = numStr.length - 1; i >= 0; i--) {
      if (counter == 3) {
        result = ',$result';
        counter = 0;
      }
      result = numStr[i] + result;
      counter++;
    }
    return result;
  }
}
