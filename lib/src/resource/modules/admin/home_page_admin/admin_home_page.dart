import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:safe_food/config/app_text_style.dart';
import 'package:safe_food/src/resource/model/bill.dart';
import 'package:safe_food/src/resource/model/bill_item.dart';
import 'package:safe_food/src/resource/model/product.dart';
import 'package:safe_food/src/resource/model/top_product_selling.dart';
import 'package:safe_food/src/resource/model/user.dart';
import 'package:safe_food/src/resource/modules/admin/pending_order/pending_order_screen.dart';
import 'package:safe_food/src/resource/modules/admin/charts/order_chart.dart';
import 'package:safe_food/src/resource/modules/admin/stock/stock_available.dart';
import 'package:safe_food/src/resource/modules/admin/user_analyst/user_screen.dart';
import 'package:safe_food/src/resource/modules/user/introduce/introduce.dart';
import 'package:safe_food/src/resource/provider/bill_provider.dart';
import 'package:safe_food/src/resource/provider/product_provider.dart';
import 'package:safe_food/src/resource/provider/user_provider.dart';
import 'package:safe_food/src/resource/store_data/store_data.dart';
import 'package:safe_food/src/resource/utils/enums/helpers.dart';

import '../../../../../config/app_color.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  void initState() {
    Provider.of<BillProvider>(context, listen: false).getListBill();
    Provider.of<BillProvider>(context, listen: false).getListBillItemPending();
    Provider.of<ProductProvider>(context, listen: false).getListProduct();
    Provider.of<UserProvider>(context, listen: false).getListUser();
    Provider.of<ProductProvider>(context, listen: false).getListTopSelling();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final NumberFormat decimalFormat =
        NumberFormat.simpleCurrency(locale: 'vi-VN');

    final billProvider = Provider.of<BillProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    final List<Bill> listBill = billProvider.listBill;
    final List<BillItem> listBillPending = billProvider.listBillItem;
    final List<Product> listProduct = productProvider.listProduct;
    final List<User> listUser = userProvider.listUser;
    final List<TopProductSelling> listTopSelling =
        productProvider.listTopSelling;

    double getSales() {
      double total = 0;
      listBill.forEach((item) {
        total += double.parse(item.totalPayment.toString());
      });
      return total;
    }

    return Container(
      decoration: const BoxDecoration(color: Color(0xFFf5f5fa)),
      child: billProvider.isLoad
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Scaffold(
              appBar: AppBar(
                  backgroundColor: const Color(0xFFf5f5fa),
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  centerTitle: true,
                  actions: [
                    IconButton(
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.grey,
                      ),
                      onPressed: () async {
                        await StoreData()
                            .clearSharedPreferences()
                            .then((_) => {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => IntroScreen()))
                                })
                            .catchError(
                                (error) => {showErrorDialog(context, error)});
                      },
                    ),
                  ]),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 4, right: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: Container(
                              width: size.width / 2 - 20,
                              height: size.width / 2 - 30,
                              decoration: const BoxDecoration(
                                  gradient: AppTheme.gradient_analyse1,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      FontAwesomeIcons.chartSimple,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(decimalFormat.format(getSales()),
                                        style: AppTextStyle.heading2Light),
                                    const Text('All sales',
                                        style: AppTextStyle.heading3pLight),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      'Tap to view',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          height: 1.6,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BillItemScreen()));
                            },
                            child: Container(
                              width: size.width / 2 - 20,
                              height: size.width / 2 - 30,
                              decoration: const BoxDecoration(
                                  gradient: AppTheme.gradient_analyse2,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      FontAwesomeIcons.listCheck,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text('${listBillPending.length}',
                                        style: AppTextStyle.heading2Light),
                                    const Text('Pending Order',
                                        style: AppTextStyle.heading3pLight),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      'Tap to view',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          height: 1.6,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => StockAvailable()));
                            },
                            child: Container(
                              width: size.width / 2 - 20,
                              height: size.width / 2 - 30,
                              decoration: const BoxDecoration(
                                  gradient: AppTheme.gradient_analyse3,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      FontAwesomeIcons.warehouse,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text('${listProduct.length}',
                                        style: AppTextStyle.heading2Light),
                                    const Text('Stock Available',
                                        style: AppTextStyle.heading3pLight),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      'Tap to view',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          height: 1.6,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UserScreen()));
                            },
                            child: Container(
                              width: size.width / 2 - 20,
                              height: size.width / 2 - 30,
                              decoration: const BoxDecoration(
                                  gradient: AppTheme.gradient_analyse4,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      FontAwesomeIcons.users,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text('${listUser.length}',
                                        style: AppTextStyle.heading2Light),
                                    const Text('All Customer',
                                        style: AppTextStyle.heading3pLight),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      'Tap to view',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          height: 1.6,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 7, top: 7),
                        child: Text(
                          'Order Overview',
                          style: TextStyle(
                              fontFamily: 'Poppins-Bold', fontSize: 18),
                        ),
                      ),
                      Container(
                        width: size.width,
                        padding: const EdgeInsets.symmetric(horizontal: 7),
                        child: const LineChartSample2(),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 7),
                        child: Text(
                          'Top selling',
                          style: TextStyle(
                              fontFamily: 'Poppins-Bold', fontSize: 18),
                        ),
                      ),
                      Container(
                        width: size.width,
                        height: size.height / 2,
                        padding: EdgeInsets.only(top: 10),
                        margin: EdgeInsets.all(5),
                        child: ListView.builder(
                          itemCount: listTopSelling.length,
                          itemBuilder: (context, index) {
                            return Container(
                              height: 120,
                              padding: const EdgeInsets.only(top: 10),
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Colors.grey, width: 0.5),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 80,
                                    height: 80,
                                    child: Image.network(
                                        '${listTopSelling[index].product!.imageOrigin}'),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 250,
                                        child: Text(
                                          '${listTopSelling[index].product!.name}',
                                          style: AppTextStyle.heading3Black,
                                          maxLines: 2,
                                        ),
                                      ),
                                      Text(
                                        'Price: ${decimalFormat.format(double.parse(listTopSelling[index].product!.price!))}',
                                        style: AppTextStyle.heading3Black,
                                      ),
                                      Text(
                                        'Total selling: ${listTopSelling[index].totalQuantity}',
                                        style: AppTextStyle.heading3Black,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
