import 'dart:io';

import 'package:chfclient/Classes/ClientAccounts.dart';
import 'package:chfclient/Classes/ClientActiveOrderTile.dart';
import 'package:chfclient/Classes/ClientAdreesTile.dart';
import 'package:chfclient/Classes/ClientFoodTile.dart';
import 'package:chfclient/Classes/ClientOrderHistoryTile.dart';
import 'package:chfclient/Classes/FinishedClientFoodTile.dart';
import 'package:chfclient/Classes/RestaurantAccounts.dart';
import 'package:chfclient/Common/Common%20Classes/CommentTile.dart';
import 'package:chfclient/Common/Common%20Classes/Date.dart';
import 'package:chfclient/Common/Common%20Classes/Food.dart';
import 'package:chfclient/Common/Common%20Classes/RestaurantTile.dart';
import 'package:chfclient/Common/Text/ClientMyTextFormField.dart';
import 'package:chfclient/Screens/ClientActiveOrdersScreen.dart';
import 'package:chfclient/Screens/CartScreen.dart';
import 'package:chfclient/Screens/ClientHomeScreen.dart';
import 'package:chfclient/Screens/ClientOrdersHistoryScreen.dart';
import 'package:chfclient/Screens/SetpointScreeen.dart';
import 'package:chfclient/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:search_page/search_page.dart';

class customListTile extends StatefulWidget {
  IconData icon;
  String text;
  Function ontap;

  customListTile(this.icon, this.text, this.ontap);

  @override
  _customListTileState createState() => _customListTileState();
}

class _customListTileState extends State<customListTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: InkWell(
        splashColor: Colors.deepOrange,
        onTap: widget.ontap,
        child: Container(
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(widget.icon),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.text,
                      style: TextStyle(fontSize: 13, fontFamily: 'HotPizza'),
                    ),
                  )
                ],
              ),
              Icon(Icons.arrow_right),
            ],
          ),
        ),
      ),
    );
  }
}

class ClientMainMenuScreen extends StatefulWidget {
  static LatLng location;
  static List<LatLng> tappedPoints = [];
  static List<RestaurantTile> res = [];
  static bool activeOrder = false;
  static bool changeAppBarAddress = false;
  static bool isOrderFinished = true;

  @override
  _ClientMainMenuScreenState createState() => _ClientMainMenuScreenState();
}

class _ClientMainMenuScreenState extends State<ClientMainMenuScreen> {
  var _key1 = GlobalKey<FormState>();

  void refreshPage() {
    if (this.mounted) {
      setState(() {});
    }
  }

  int _currentSelect = 1;
  bool isSearching = false;
  List<Widget> screens = [
    CartScreen(),
    ClientHomeScreen(),
  ];
  String appBarText = '        -';

  /*ClientAccounts
      .accounts[ClientAccounts.currentAccount]
      .address[
          ClientAccounts.accounts[ClientAccounts.currentAccount].currentAddress]
      .address*/

  void addressButtonSheet() {
    ClientAddressTile.trailing = false;
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Card(
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(11.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Address List',
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (context) {
                                var markers = ClientMainMenuScreen.tappedPoints
                                    .map((latlng) {
                                  return Marker(
                                    width: 80.0,
                                    height: 80.0,
                                    point: latlng,
                                    builder: (ctx) => Container(
                                      child: Icon(
                                        Icons.location_on,
                                        size: 50,
                                        color: Colors.red,
                                      ),
                                    ),
                                  );
                                }).toList();
                                return SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.75,
                                  child: ListView(
                                    children: [
                                      Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 8.0, bottom: 8.0),
                                            child: Text('Hold to add pins'),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              height: 300,
                                              child: FlutterMap(
                                                options: MapOptions(
                                                    center: LatLng(
                                                        35.715298, 51.404343),
                                                    zoom: 13.0,
                                                    onTap: _handleTap),
                                                layers: [
                                                  TileLayerOptions(
                                                    urlTemplate:
                                                        "https://api.mapbox.com/styles/v1/amirrza/ckov1rtrs059m17p8xugrutr4/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYW1pcnJ6YSIsImEiOiJja292MW0zeGwwNDN1MnBwYzlhbDVyOHByIn0.Mwa8L0WNjyIKc-v32nKOhQ",
                                                  ),
                                                  MarkerLayerOptions(
                                                      markers: markers)
                                                ],
                                              ),
                                            ),
                                          ),
                                          Form(
                                            key: _key1,
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: ClientMyTextFormField(
                                                    "Address",
                                                    index: 3,
                                                    hint: "Your new address",
                                                    addToAccounts: true,
                                                    regex: 'Address',
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 350,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            primary: Theme.of(
                                                                    context)
                                                                .primaryColor),
                                                    onPressed: () {
                                                      ClientMyTextFormField
                                                              .location =
                                                          ClientMainMenuScreen
                                                              .location;
                                                      if (_key1.currentState
                                                          .validate()) {
                                                        _key1.currentState
                                                            .save();
                                                        if (ClientAccounts
                                                                .accounts[
                                                                    ClientAccounts
                                                                        .currentAccount]
                                                                .getAddressLength() ==
                                                            1) {
                                                          setState(() {
                                                            appBarTitle(1);
                                                          });
                                                        }
                                                        Navigator.pop(context);
                                                        Navigator.pop(context);
                                                      }
                                                    },
                                                    child: Text('Save'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                          // ElevatedButton(onPressed: ()=> print(ProfileScreen.tappedPoints), child: Text("save"))
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              });
                        },
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'New Address',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Column(
                  children: List.generate(
                      ClientAccounts.accounts[ClientAccounts.currentAccount]
                          .getAddressLength(),
                      (index) => ClientAccounts
                          .accounts[ClientAccounts.currentAccount]
                          .address[index]),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void orderCalculator(String listen, bool flag) {
    if (flag) {
      ClientAccounts.accounts[ClientAccounts.currentAccount].activeOrders = [];
    } else {
      ClientAccounts.accounts[ClientAccounts.currentAccount].ordersHistory = [];
    }
    if (listen != 'invalid...invalid...invalid') {
      List<String> split = listen.split('...');
      List<String> data = split[0].split('\n');
      List<String> foods = split[1].split('\n');
      List<String> numbers = split[2].split('\n');
      print('your data is: ' + data.toString());
      for (int i = 0; i < data.length; i++) {
        List<String> foodsElements = foods[i].split('+');
        List<Food> foodsAns = [];
        for (int j = 0; j < foodsElements.length; j++) {
          List<String> foodIndex = foodsElements[j].split(', ');
          foodsAns.add(Food(foodIndex[1], foodIndex[3], true, foodIndex[0],
              desc: foodIndex[2] == 'null' ? '' : foodIndex[2]));
        }
        List<String> numbersElements = numbers[i].split(', ');
        List<int> numbersAns = [];
        for (int j = 0; j < numbersElements.length; j++) {
          numbersAns.add(int.parse(numbersElements[j]));
        }
        List<String> dataAns = data[i].split(', ');
        List<String> dateElements = dataAns[5].split(':');
        String restAddress = '';
        int indexRest = 0;
        for (int u = 0; u < RestaurantAccounts.restaurantList[0].length; u++) {
          if (RestaurantAccounts.restaurantList[0][u].phoneNumber ==
              dataAns[1]) {
            restAddress = RestaurantAccounts.restaurantList[0][u].address;
            indexRest = u;
          }
        }
        Map<int, String> cartName = {-1: 'All'};
        Map<int, int> cartNum = {-1: 0};
        Map<int, double> cartSum = {-1: 0};
        Map cartCategory = {};
        for (int u = 0; u < foodsAns.length; u++) {
          cartName[u] = foodsAns[u].name;
          cartNum[u] = numbersAns[u];
          for (int kk = 0;
              kk <
                  RestaurantAccounts
                      .restaurantList[0][indexRest].clientTabBarView[0].length;
              kk++) {
            print('cartName[u]: ' + cartName[u]);
            print(
                "RestaurantAccounts.restaurantList[0][indexRest].clientTabBarView[0][kk].name: " +
                    RestaurantAccounts.restaurantList[0][indexRest]
                        .clientTabBarView[0][kk].name);
            if (RestaurantAccounts.restaurantList[0][indexRest]
                    .clientTabBarView[0][kk].name ==
                cartName[u]) {
              cartSum[u] = double.parse(RestaurantAccounts
                  .restaurantList[0][indexRest].clientTabBarView[0][kk].price);
              cartCategory[u] = RestaurantAccounts.restaurantList[0][indexRest]
                  .clientTabBarView[0][kk].category;
              print('---------------------');
              print('hiiiiiiiiiiiii');
              print('---------------------');
            }
            cartNum[-1] += cartNum[u];
            cartSum[-1] += cartSum[u];
          }
        }
        List<FinishedClientFoodTile> finishFoods = [];
        for (int u = 0; u < cartName.length - 1; u++) {
          finishFoods.add(FinishedClientFoodTile(
              cartName[u],
              (cartSum[u] / cartNum[u]).toString(),
              cartNum[u],
              cartCategory[u]));
        }
        if (flag) {
          ClientAccounts.accounts[ClientAccounts.currentAccount].addOrder(
              ClientActiveOrderTile(
                  dataAns[2],
                  Date(
                      year: dateElements[0]
                          .substring(dateElements[0].indexOf('(') + 1),
                      month: dateElements[1],
                      day: dateElements[2],
                      hour: dateElements[3],
                      minute: dateElements[4],
                      second: dateElements[5]
                          .substring(0, dateElements[5].indexOf(')'))),
                  dataAns[3],
                  restAddress,
                  cartSum,
                  cartName,
                  cartNum,
                  finishFoods));
        } else {
          print('dataAns[0]: ' + dataAns[0]);
          ClientAccounts.accounts[ClientAccounts.currentAccount]
              .addHistoryOrder(ClientOrderHistoryTile(
                  dataAns[2],
                  Date(
                      year: dateElements[0]
                          .substring(dateElements[0].indexOf('(') + 1),
                      month: dateElements[1],
                      day: dateElements[2],
                      hour: dateElements[3],
                      minute: dateElements[4],
                      second: dateElements[5]
                          .substring(0, dateElements[5].indexOf(')'))),
                  dataAns[3],
                  restAddress,
                  cartSum,
                  cartName,
                  cartNum,
                  finishFoods,
                  dataAns[6],
                  dataAns[1],
                  dataAns[0]));
        }
      }
    }
  }

  void appBarTitle(int value) async {
    _currentSelect = value;
    if (_currentSelect == 2) {
      String listen = '';
      await Socket.connect(MyApp.ip, 2442).then((serverSocket) {
        print('connected writer');
        String write = '';
        write += 'ClientOrders-ClientActiveOrdersData-' +
            MyApp.id +
            '-' +
            'ClientActiveOrdersFoodNames-' +
            MyApp.id +
            '-' +
            'ClientActiveOrdersNumbers-' +
            MyApp.id;
        write = (write.length + 7).toString() + ',Client-' + write;
        serverSocket.write(write);
        serverSocket.flush();
        print('write: ' + write);
        print('connected listen');
        serverSocket.listen((socket) {
          listen = String.fromCharCodes(socket).trim().substring(2);
        }).onDone(() async {
          print("listen: " + listen);
          orderCalculator(listen, true);
          String listenOrdersHistory = '';
          await Socket.connect(MyApp.ip, 2442).then((serverSocket) {
            print('connected writer');
            String write = '';
            write += 'ClientOrders-ClientOrdersHistoryData-' +
                MyApp.id +
                '-' +
                'ClientOrdersHistoryFoodNames-' +
                MyApp.id +
                '-' +
                'ClientOrdersHistoryNumbers-' +
                MyApp.id;
            write = (write.length + 7).toString() + ',Client-' + write;
            serverSocket.write(write);
            serverSocket.flush();
            print('write: ' + write);
            print('connected listen');
            serverSocket.listen((socket) {
              listenOrdersHistory =
                  String.fromCharCodes(socket).trim().substring(2);
            }).onDone(() async {
              print("listen: " + listenOrdersHistory);
              orderCalculator(listenOrdersHistory, false);
              setState(() {
                appBarText = 'Orders';
                if (ClientMainMenuScreen.isOrderFinished) {}
              });
            });
          });
        });
      });
    } else {
      setState(() {
        if (_currentSelect == 0) {
          appBarText = 'Cart';
        } else if (_currentSelect == 1) {
          appBarText = ClientAccounts.accounts[ClientAccounts.currentAccount]
                      .getAddressLength() ==
                  0
              ? '        -'
              : ClientAccounts
                  .accounts[ClientAccounts.currentAccount]
                  .address[ClientAccounts
                      .accounts[ClientAccounts.currentAccount].currentAddress]
                  .address;
        }
      });
    }
  }

  // void pointDialog() {
  //   showDialog(context: context, builder: (context) =>
  //       AlertDialog(
  //         title: Text("Enter point : "),
  //         content: Column(
  //           children: [
  //             Row(
  //               children: [
  //                 Icon(Icons.star),
  //                 Icon(Icons.star),
  //                 Icon(Icons.star),
  //                 Icon(Icons.star),
  //                 Icon(Icons.star)
  //               ],
  //             ),
  //             Row(
  //               children: [ElevatedButton(/*onPressed:,*/ //TODO
  //                   child: Text("Save"))
  //               ],
  //             )
  //           ],
  //         ),
  //       ),);
  // }

  @override
  Widget build(BuildContext context) {
    ClientAddressTile.mainMenu = refreshPage;
    if (ClientMainMenuScreen.activeOrder) {
      // setState(() {
      _currentSelect = 2;
      appBarTitle(2);
      ClientMainMenuScreen.activeOrder = false;
      // });
    }
    if (ClientMainMenuScreen.changeAppBarAddress) {
      // setState(() {
      appBarTitle(1);
      ClientMainMenuScreen.changeAppBarAddress = false;
      // });
    }
    return DefaultTabController(
      length: 2,
      initialIndex: 1,
      child: Scaffold(
        body: _currentSelect != 2
            ? screens[_currentSelect]
            : TabBarView(children: [
                ClientOrdersHistoryScreen(),
                ClientActiveOrdersScreen(),
              ]),
        drawer: (Drawer(
            child: ListView(
          children: [
            DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.orange,
                    Colors.deepOrange,
                  ]),
                ),
                child: Center(
                  child: Image.asset('assets/images/5.png'),
                )),
            customListTile(Icons.person, 'Profile',
                () => Navigator.pushNamed(context, '/ProfileScreen')),
            customListTile(Icons.credit_card_outlined, 'My Wallet',
                () => Navigator.pushNamed(context, '/WalletScreen')),
            customListTile(Icons.favorite_border, 'My Fav Restaurants ',
                () => Navigator.pushNamed(context, '/FavRestaurantsScreen')),
            customListTile(Icons.comment, 'My Comments ', () async {
              String listen = '';
              await Socket.connect(MyApp.ip, 2442).then((serverSocket) {
                print('connected writer');
                String write = 'Comments-ClientComments-' + MyApp.id;
                write = (write.length + 7).toString() + ',Client-' + write;
                serverSocket.write(write);
                serverSocket.flush();
                print('write: ' + write);
                print('connected listen');
                serverSocket.listen((socket) {
                  listen = String.fromCharCodes(socket).trim().substring(2);
                }).onDone(() {
                  print("listen: " + listen);

                  if (listen != null && listen.isNotEmpty) {
                    // List test = [];
                    // for (int u = 1;
                    // u <
                    //     ClientAccounts
                    //         .accounts[ClientAccounts.currentAccount]
                    //         .clientComments
                    //         .length;
                    // u++) {
                    //   test[u] = [];
                    // }
                    ClientAccounts.accounts[ClientAccounts.currentAccount]
                        .clientComments = [] /*test*/;
                    List<String> comments = listen.split('\n');
                    for (int i = 0; i < comments.length; i++) {
                      List<String> commentElements = comments[i].split(', ');
                      // int index = 0;
                      // for (int j = 1;
                      // j <
                      //     ClientAccounts
                      //         .accounts[ClientAccounts.currentAccount]
                      //         .restaurantTabBarView
                      //         .length;
                      // j++) {
                      //   for (int k = 0;
                      //   k <
                      //       Accounts
                      //           .accounts[
                      //       Accounts.currentAccount]
                      //           .restaurantTabBarView[j]
                      //           .length;
                      //   k++) {
                      //     if (Accounts
                      //         .accounts[Accounts.currentAccount]
                      //         .restaurantTabBarView[j][k]
                      //         .name ==
                      //         commentElements[3]) {
                      //       index = j;
                      //     }
                      //   }
                      // }
                      List<String> dateElements = commentElements[5].split(':');
                      Date date = Date(
                          year: dateElements[0]
                              .substring(dateElements[0].indexOf('(') + 1),
                          month: dateElements[1],
                          day: dateElements[2],
                          hour: dateElements[3],
                          minute: dateElements[4],
                          second: dateElements[5]
                              .substring(0, dateElements[5].indexOf(')')));
                      // print('index is: ' + index.toString());
                      for (int y = 0; y < commentElements.length; y++) {
                        print("element is: " + commentElements[y]);
                      }
                      ClientAccounts.accounts[ClientAccounts.currentAccount]
                          .addComment(CommentTile(
                        commentElements[1],
                        commentElements[3],
                        date,
                        commentElements[0]
                            .substring(0, commentElements[0].indexOf(':')),
                        commentElements[4],
                        answer: (commentElements[2] == 'null'
                            ? ''
                            : commentElements[2]),
                      ));
                    }
                  }
                  Navigator.pushNamed(context, '/CommentsScreen');
                });
                // serverSocket.close();
              });
            }),
            customListTile(
                Icons.phone,
                'Contact Us',
                () => () {
                      Navigator.pushNamed(context, "/ContactUsScreen");
                    }),
            customListTile(Icons.control_point_sharp, ' Set point ', () {
              List<String> x = [];
              for (int i = 0;
                  i <
                      ClientAccounts.accounts[ClientAccounts.currentAccount]
                          .ordersHistory.length;
                  i++) {
                x.add(ClientAccounts.accounts[ClientAccounts.currentAccount]
                    .ordersHistory[i].restaurantName);
              }
              SetPointScreen.x = x;
              Navigator.pushNamed(context, '/SetPointScreen');
            }),
            customListTile(
                Icons.phone,
                'Contact Us',
                () => () {
                      Navigator.pushNamed(context, "/ContactUsScreen");
                    }),
            customListTile(
              Icons.logout,
              "Log Out",
              () {
                MyApp.id = '';
                MyApp.mode = 'LogOut';
                // RestaurantProfileScreen.tappedPoints = [];
                ClientAccounts.key = false;
                ClientAccounts.currentAccount = 0;
                Navigator.popUntil(
                    context, ModalRoute.withName('/ClientSignInScreen'));
                Navigator.pushNamed(context, '/ClientSignInScreen');
              },
            ),
          ],
        ))),
        appBar: AppBar(
            actions: [
              _currentSelect == 1
                  ? IconButton(
                      icon: Icon(
                        Icons.search,
                        size: 30,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        //TODO
                        showSearch(
                            context: context,
                            delegate: SearchPage<RestaurantTile>(
                                onQueryUpdate: (s) => print(s),
                                searchLabel: 'Search people',
                                suggestion: Center(
                                  child: Text('Filter restaurants by name'),
                                ),
                                failure: Center(
                                    child: Text('No restaurant found :(')),
                                builder: (RestaurantTile rs) => rs,
                                filter: (RestaurantTile rt) => [rt.name],
                                items: RestaurantAccounts.restaurantList[0]));
                      },
                    )
                  : Container(
                      height: 0,
                      width: 0,
                    )
            ],
            bottom: _currentSelect == 2
                ? TabBar(
                    unselectedLabelColor: Colors.white.withOpacity(0.3),
                    indicatorColor: Colors.white,
                    tabs: [
                        Tab(
                          child: Text('Orders History'),
                        ),
                        Tab(
                          child: Text('Active Orders'),
                        ),
                      ])
                : null,
            centerTitle: true,
            title: isSearching
                ? Form(child: TextFormField())
                : (_currentSelect != 1
                    ? Text(appBarText)
                    : GestureDetector(
                        onTap: () => addressButtonSheet(),
                        child: Row(
                          children: [
                            Padding(padding: EdgeInsets.fromLTRB(80, 0, 0, 0)),
                            Text(/*' ' + */ ClientAccounts.digester(
                                appBarText, 10)),
                            Icon(Icons.keyboard_arrow_down),
                          ],
                        ),
                      ))),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentSelect,
          onTap: (value) => appBarTitle(value),
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_outlined), label: 'Cart'),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.history), label: 'Orders History'),
          ],
        ),
      ),
    );
  }

  void _handleTap(LatLng latlng) {
    setState(() {
      if (ClientMainMenuScreen.tappedPoints.isEmpty) {
        ClientMainMenuScreen.tappedPoints.add(latlng);
      } else {
        ClientMainMenuScreen.tappedPoints.clear();
        ClientMainMenuScreen.tappedPoints.add(latlng);
      }
      ClientMainMenuScreen.location = latlng;
      print(ClientMainMenuScreen.tappedPoints);
    });
  }
}
