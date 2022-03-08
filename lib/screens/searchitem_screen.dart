import '../../controller/mutations/cart_mutation.dart';
import '../controller/mutations/home_screen_mutation.dart';
import '../models/VxModels/VxStore.dart';
import '../models/newmodle/product_data.dart';
import '../repository/productandCategory/category_or_product.dart';
import '../components/sellingitem_component.dart';
import 'package:velocity_x/velocity_x.dart';

import '../constants/features.dart';
import '../generated/l10n.dart';
import '../rought_genrator.dart';
import '../widgets/bottom_navigation.dart';

import '../services/firebaseAnaliticsService.dart';
import '../widgets/simmers/item_list_shimmer.dart';
import '../blocs/search_item_bloc.dart';
import '../blocs/sliderbannerBloc.dart';

import '../constants/IConstants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/itemslist.dart';
import '../data/calculations.dart';
import '../assets/images.dart';
import '../utils/ResponsiveLayout.dart';
import '../utils/prefUtils.dart';
import '../widgets/footer.dart';
import '../widgets/header.dart';
import '../assets/ColorCodes.dart';

class SearchitemScreen extends StatefulWidget {
  static const routeName = '/searchitem-screen';
  String itemname = "";
  Map<String,String>? search;
  SearchitemScreen(Map<String, String> params){
    this.search= params;
    this.itemname = params["itemname"]??"" ;
  }

  @override
  _SearchitemScreenState createState() => _SearchitemScreenState();
}

class _SearchitemScreenState extends State<SearchitemScreen> with Navigations{
  bool shimmereffect = true;
  var notificationData;
  int unreadCount = 0;
  bool checkskip = false;
  var popularSearch;
  bool _isSearchShow = false;
  bool _issearchloading = false;
  List searchDispaly = [];
  var searchData;
  String searchValue = "";
  bool _isShowItem = false;
  bool _isLoading = false;
  FocusNode _focus = new FocusNode();
  bool _isNoItem = false;
  bool _checkmembership = false;

  var _address = "";
  var _membership = "";
  ProductRepo _searshproductrepo = ProductRepo();
  var itemname;
  var itemid;
  var itemimg;
  bool iphonex = false;

  var searchDispalyvar = [];

  bool issearchloading = true;

    Future<List<ItemData>>? future;

   StateSetter? setstate;

  bool _isOnScroll =false;

  List<ItemData> listitem =[];

  bool endOfProduct = false;
  bool loading = false;

  @override
  void initState() {
    bloc.SearcheditemBloc();
    sbloc.searchItemsBloc();
    Future.delayed(Duration.zero, () async {

      _address = PrefUtils.prefs!.getString("restaurant_address")!;
      setState(() {
        if((VxState.store as GroceStore).userData.membership! == "1"){
          _checkmembership = true;
        } else {
          _checkmembership = false;
        }
      });
        if (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)) {
        var routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
        itemname = widget.itemname;//routeArgs['itemname'];
        itemid = routeArgs['itemid'];
        itemimg = routeArgs['itemimg'];
        _isShowItem = true;
      }
      // setstate(() {
      //   future = _searshproductrepo.getSearchQuery(itemname);
      // });

      future = _searshproductrepo.getSearchQuery(itemname);
      //Provider.of<CartItems>(context,listen: false).fetchCartItems();
    });

    /*(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))
        ? _focus.addListener(_onFocusChangeWeb)
        :*/ _focus.addListener(_onFocusChange);
    super.initState();
  }

  void _onFocusChangeWeb() {
    setState(() {
      if (_focus.hasFocus.toString() == "true") {
        debugPrint("hello3...");
        _isShowItem = true;
        _isLoading = false;
        search(itemname);
      } else {
        _isShowItem = true;
      }
    });
  }

  void _onFocusChange() {
    setState(() {
      if (_focus.hasFocus.toString() == "true") {
        _isShowItem = false;
        _isLoading = false;
      } else {
        //_isShowItem = false;
      }
    });
  }

  search(String value) async {
    //sbloc.searchiemsof.add(value);
    /*StreamBuilder<List<SellingItemsFields>>(
      stream: sbloc.serchItems,
      builder: (context,AsyncSnapshot<List<SellingItemsFields>> snapshot){
        return ;
      },
    );*/
    _issearchloading = true;
    await Provider.of<ItemsList>(context,listen: false).fetchsearchItems(value,true).then((isdone) {
      Future.delayed(Duration(milliseconds: 100), () {
        setState(() {
          _issearchloading = false;
          _isSearchShow = true;
          searchData = Provider.of<ItemsList>(context,listen: false);
          searchDispaly = searchData.searchitems.toList();
          if (searchDispaly.length <= 0) {
            _isNoItem = true;
          } else {
            _isNoItem = false;

          }

        });

      });
    });
    setstate!(() {
      itemname =value;
     future = _searshproductrepo.getSearchQuery(value);
   });
  }

  onSubmit(String value) async {
    fas.LogSearchItem(search: value);
    //FocusScope.of(context).requestFocus(_focus);
    /*_focus = new FocusNode();
    FocusScope.of(context).requestFocus(_focus);*/
    setState(() {
      _isShowItem = true;
      _isLoading = true;
    });

    setstate!(() {
      itemname =value;
      future = _searshproductrepo.getSearchQuery(value);
    });
   /* if(Features.isfacebookappevent)
      FaceBookAppEvents.facebookAppEvents.logSearch(itemname: value);*/

    // sbloc.searchiemsof.add(value);
/*    await Provider.of<ItemsList>(context,listen: false).fetchsearchItems(value).then((_) {
      searchData = Provider.of<ItemsList>(context,listen: false);
      searchDispaly = searchData.searchitems.toList();
      if (searchDispaly.length <= 0) {
        _isNoItem = true;
      } else {
        _isNoItem = false;
      }
      _isShowItem = true;
      _isLoading = false;
    });*/
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _focus.dispose();
    /*sbloc.dispose();
    bloc.dispose();*/
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    _buildBottomNavigationBar() {
      return VxBuilder(
        mutations: {SetCartItem},
        // valueListenable: Hive.box<Product>(productBoxName).listenable(),
        builder: (context,GroceStore store, index) {
          final box = (VxState.store as GroceStore).CartItemList;
          if (box.isEmpty) return SizedBox.shrink();
          return BottomNaviagation(
            itemCount: CartCalculations.itemCount.toString() + " " + S .of(context).items,
            title: S .current.view_cart,
            total: _checkmembership ? (CartCalculations.totalMember).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)
                :
            (CartCalculations.total).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
            onPressed: (){
              setState(() {
            /*    Navigator.of(context)
                    .pushNamed(CartScreen.routeName, arguments: {
                  "afterlogin": ""
                });*/
                Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
              });
            },
          );
        },
      );

      /*if(Calculations.itemCount > 0) {
        return Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: 50.0,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                height:50,
                width:MediaQuery.of(context).size.width * 35/100,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 15.0,
                    ),
                    _checkmembership
                        ?
                    Text(IConstants.currencyFormat + (Calculations.totalMember).toString(), style: TextStyle(color: Colors.black),)
                        :
                    Text(IConstants.currencyFormat + (Calculations.total).toString(), style: TextStyle(color: Colors.black),),
                    Text(Calculations.itemCount.toString() + " item", style: TextStyle(color:Colors.black,fontWeight: FontWeight.w400,fontSize: 9),)
                  ],
                ),),
              GestureDetector(
                  onTap: () =>
                  {
                    setState(() {
                      Navigator.of(context).pushNamed(CartScreen.routeName);
                    })
                  },
                  child: Container(color: Theme.of(context).primaryColor, height:50,width:MediaQuery.of(context).size.width*65/100,
                      child:Column(children:[
                        SizedBox(height: 17,),
                        Text('VIEW CART', style: TextStyle(fontSize: 12.0, color: Colors.white, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                      ]
                      )
                  )
              ),
            ],
          ),
        );
      }*/
    }

    return WillPopScope(
      onWillPop: (){
       // Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        Navigator.of(context).pop();
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: ColorCodes.whiteColor,
        appBar: (ResponsiveLayout.isSmallScreen(context))?_searchContainermobile():null ,
        body: Column(children: <Widget>[
          if (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)) Header(false,onsearchClick: (queery){
            setstate!((){
              endOfProduct = false;
              listitem.clear();
              _isShowItem = true;
              itemname = queery;
              future = _searshproductrepo.getSearchQuery(queery);
            });
          },),
          Expanded(
            child: NotificationListener<
                ScrollNotification>(
              // ignore: missing_return
              onNotification: (ScrollNotification scrollInfo) {
                if (!endOfProduct) if (!_isOnScroll &&
                // ignore: missing_return
                scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                  setstate!(() {
                    _isOnScroll = true;
                    future = _searshproductrepo.getSearchQuery(itemname,start: listitem.length);
                    future!.then((value) {
                      _isOnScroll = false;
                      if(value.isEmpty){
                        endOfProduct = true;
                      }
                    });
                  });
                }
                return true;
              },
              child: SingleChildScrollView(
                child: StatefulBuilder(
                    builder: (context,setState){
                      setstate = setState;
                      return Column(children: [
                        /// display list of search item
                        if (_isShowItem)//Show Searched Items

                          FutureBuilder<List<ItemData>> (
                            future: future,
                            builder: (context,  snapshot){
                              bool shimmerloading = false;

                              switch(snapshot.connectionState){
                              // case ConnectionState.none:
                              //   // TODO: Handle this case.
                              //   break;
                                case ConnectionState.waiting:
                                  shimmerloading =listitem.isEmpty;
                                  loading = true;
                                  // return Container(
                                  //   height: MediaQuery.of(context).size.height - 130.0,
                                  //   child: Center(child: listitem.isEmpty?ItemListShimmer():Column(
                                  //     children: [
                                  //       _ListSerchItem(),
                                  //       if(!Vx.isWeb) Container(
                                  //         height: 50,
                                  //         child: Center(
                                  //           child: new CircularProgressIndicator(),
                                  //         ),
                                  //       )
                                  //     ],
                                  //   )),
                                  // );
                                  // TODO: Handle this case.
                                  break;
                              // case ConnectionState.active:
                              //   // TODO: Handle this case.
                              //   break;
                                case ConnectionState.done:
                                  shimmerloading =false;
                                  loading = false;
                                  // return _ListSerchItem(snapshot);
                                  // TODO: Handle this case.
                                  break;
                                default:
                                  shimmerloading =false;
                                  loading = false;
                              // return SizedBox.shrink();
                              }
                              return shimmerloading?ItemListShimmer():Column(
                                children: [
                                  _ListSerchItem(loading?null:snapshot),
                                  /*if(loading)
                                    if(!Vx.isWeb) Container(
                                      height: 50,
                                      child: Center(
                                        child: new CircularProgressIndicator(),
                                      ),
                                    )
                                    else if(endOfProduct) Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black12,
                                      ),
                                      margin: EdgeInsets.only(top: 10.0),
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width,
                                      padding: EdgeInsets.only(top: 25.0, bottom: 25.0),
                                      child: Text(
                                        S
                                            .of(context)
                                            .thats_all_folk,
                                        // "That's all folks!",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),*/
                                ],
                              );
//                          if (snapshot.hasData) {
//                            if (snapshot.data.length <= 0) {
//                              return Container(
//                                height: MediaQuery
//                                    .of(context)
//                                    .size
//                                    .height * 0.65,
//                                child: Column(
//                                  mainAxisAlignment: MainAxisAlignment.start,
//                                  // crossAxisAlignment: CrossAxisAlignment.center,
//                                  children: [
//                                    Align(
//                                      alignment: Alignment.center,
//                                      child: new Image.asset(
//                                        Images.noItemImg,
//                                        fit: BoxFit.fill,
//                                        height: 250.0,
//                                        width: 200.0,
// //                    fit: BoxFit.cover
//                                      ),
//                                    ),
//                                  ],
//                                ),
//                              );//ItemListShimmer();
//                            }else{
//                              return  GridView.builder(
//                                  padding: EdgeInsets.only(top: 10.0),
//                                  shrinkWrap: true,
//                                  physics: ScrollPhysics(),
//                                  itemCount: snapshot.data.length,
//                                  gridDelegate:
//                                  new SliverGridDelegateWithFixedCrossAxisCount(
//                                    crossAxisCount: widgetsInRow,
//                                    childAspectRatio: aspectRatio,
//                                  ),
//                                  itemBuilder: (BuildContext context, int index) {
//                                    return SellingItemsv2("search_item", "", snapshot.data[0]);
//                                    // return SellingItems(
//                                    //   "searchitem_screen",
//                                    //   snapshot.data[index].id,
//                                    //   snapshot.data[index].title,
//                                    //   snapshot.data[index].imageUrl,
//                                    //   snapshot.data[index].brand,
//                                    //   "",
//                                    //   snapshot.data[index].veg_type,
//                                    //   snapshot.data[index].type,
//                                    //   snapshot.data[index].eligible_for_express,
//                                    //   "",
//                                    //   snapshot.data[index].duration,
//                                    //   snapshot.data[index].durationType,
//                                    //   snapshot.data[index].note,
//                                    //   snapshot.data[index].subscribe,
//                                    //   snapshot.data[index].paymentmode,
//                                    //   snapshot.data[index].cronTime,
//                                    //   snapshot.data[index].name,
//                                    //
//                                    // );
//                                    // return SearchedItems(
//                                    //   "searchitem_screen",
//                                    //   snapshot.data[index].id,
//                                    //   snapshot.data[index].title,
//                                    //   snapshot.data[index].imageUrl,
//                                    //   snapshot.data[index].brand,
//                                    //   "",
//                                    //   snapshot.data[index].veg_type,
//                                    //   snapshot.data[index].type,
//                                    //   snapshot.data[index].eligible_for_express,
//                                    //  "",
//                                    //   snapshot.data[index].duration,
//                                    //   snapshot.data[index].durationType,
//                                    //   snapshot.data[index].note,
//                                    //
//                                    // );
//                                  });
//                            }
//                          }else if(!snapshot.hasData){
//                            return Container(
//                              height: MediaQuery.of(context).size.height - 130.0,
//                              child: Center(child: ItemListShimmer()),
//                            );
//                            /* Container(
//                          // height: MediaQuery.of(context).size.height,
//                           child: Center(child: Expanded(
//                             child: Align(
//                               alignment: Alignment.center,
//                               child: new Image.asset(
//                                 Images.noItemImg,
//                                 fit: BoxFit.fill,
//                                 height: 200.0,
//                                 width: 200.0,
// //                    fit: BoxFit.cover
//                               ),
//                             ),
//                           ),),
//                         );*/
//                          }
//                          else{
//                            return Container(
//                              height: MediaQuery.of(context).size.height - 130.0,
//                              child: Center(child: ItemListShimmer()),
//                            );
//                          }
                            },)
                        else
                        /// display dropdown of  search item
                        //Search item list Ui
                          (ResponsiveLayout.isSmallScreen(context) || ResponsiveLayout.isMediumScreen(context)||
                              ResponsiveLayout.isLargeScreen(context))? Container (
                            // searchin...
                            width: MediaQuery.of(context).size.width,
                            //height: MediaQuery.of(context).size.height,
                            margin: EdgeInsets.all(8.0),
                            color: Theme.of(context).backgroundColor,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[

                                  SizedBox(
                                    child: FutureBuilder<List<ItemData>> (
                                        future: future,
                                        builder: (context,  snapshot){
                                          return Column(
                                            children: [
                                              if(snapshot.hasData)
                                                if (snapshot.data!.isNotEmpty)
                                                  if(_isSearchShow)
                                                    new ListView.builder(
                                                      shrinkWrap: true,
                                                      physics:
                                                      NeverScrollableScrollPhysics(),
                                                      itemCount: snapshot.data!.length,
                                                      padding: EdgeInsets.zero,
                                                      itemBuilder: (_, i) => Column(
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              Navigation(context, name: Routename.SingleProduct, navigatore: NavigatoreTyp.Push,parms: {"varid":snapshot.data![i].priceVariation!.first.id!});

                                                              // Navigator.of(context)
                                                              //     .pushNamed(
                                                              //     SingleproductScreen
                                                              //         .routeName,
                                                              //     arguments: {
                                                              //       "itemid": snapshot.data![i].id.toString(),
                                                              //       "itemname": snapshot.data![i].itemName.toString(),
                                                              //       "itemimg": snapshot.data![i].itemFeaturedImage.toString(),
                                                              //       "eligibleforexpress": snapshot.data![i].eligibleForExpress.toString(),
                                                              //       "delivery": snapshot.data![i].delivery.toString(),
                                                              //       "duration": snapshot.data![i].duration.toString(),
                                                              //       "durationType": snapshot.data![i].deliveryDuration.durationType.toString(),
                                                              //       "note": snapshot.data![i].deliveryDuration.note.toString(),
                                                              //       "fromScreen": "searchitem_screen",
                                                              //     });
                                                              // _isShowItem = true;
                                                              _isLoading = true;
                                                              FocusScope.of(context)
                                                                  .requestFocus(
                                                                  new FocusNode());
                                                              // onSubmit(searchValue);
                                                            },
                                                            child: Container(
                                                              padding: EdgeInsets.all(12.0),
                                                              decoration: BoxDecoration(
                                                                  color: Colors.white,
                                                                  border: Border(
                                                                    bottom: BorderSide(
                                                                      width: 2.0,
                                                                      color: Theme.of(
                                                                          context)
                                                                          .backgroundColor,
                                                                    ),
                                                                  )),
                                                              width: MediaQuery.of(context)
                                                                  .size
                                                                  .width,
                                                              child: Text(
                                                                snapshot.data![i].itemName!,
                                                                style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontSize: 12.0),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                              if(_issearchloading) LinearProgressIndicator(
                                                // color: ColorCodes.primaryColor,
                                                minHeight: 5,
                                              ),
                                              Column(
                                                children: [
                                                  if (ResponsiveLayout.isSmallScreen(
                                                      context))
                                                    Container(
                                                      margin: EdgeInsets.all(14.0),
                                                      child: Text(
                                                        S
                                                            .of(context)
                                                            .popular_search, //"Popular Searches"
                                                      ),
                                                      width: double.maxFinite,
                                                    ),
                                                  if (ResponsiveLayout.isSmallScreen(
                                                      context))
                                                    SizedBox(
                                                      child: VxBuilder(
                                                        mutations: {HomeScreenController},
                                                        builder: (ctx,GroceStore? store,VxStatus? state){
                                                          final snapshot = store!.homescreen.data!.featuredByCart;
                                                          //stream: bloc.featureditems,

                                                          if (snapshot!=null) {
                                                            return new ListView.builder(
                                                              shrinkWrap: true,
                                                              physics:
                                                              NeverScrollableScrollPhysics(),
                                                              itemCount:
                                                              snapshot.data!.length,
                                                              padding: EdgeInsets.zero,
                                                              itemBuilder: (_, i) =>
                                                                  Column(
                                                                    children: [
                                                                      GestureDetector(
                                                                        onTap: () {
                                                                          // Navigator.of(context).pushNamed(
                                                                              Navigation(context, name: Routename.SingleProduct, navigatore: NavigatoreTyp.Push,parms: {"varid":snapshot.data![i].priceVariation!.first.id!});
                                                                              // SingleproductScreen.routeName,
                                                                              // arguments: {
                                                                              //   "itemid": snapshot.data![i].id.toString(),
                                                                              //   "itemname": snapshot.data![i].itemName.toString(),
                                                                              //   "itemimg": snapshot.data![i].itemFeaturedImage.toString(),
                                                                              //   "eligibleforexpress": snapshot.data![i].eligibleForExpress.toString(),
                                                                              //   "delivery": snapshot.data![i].delivery.toString(),
                                                                              //   "duration": snapshot.data![i].duration.toString(),
                                                                              //   "durationType": snapshot.data![i].deliveryDuration.durationType.toString(),
                                                                              //   "note": snapshot.data![i].deliveryDuration.note.toString(),
                                                                              //   "fromScreen": "searchitem_screen",
                                                                              // });
                                                                          /*                                        _isShowItem = true;

                                                                        _isLoading = true;
                                                                        FocusScope.of(
                                                                            context)
                                                                            .requestFocus(
                                                                            new FocusNode());
                                                                        */
                                                                        },
                                                                        child: Container(
                                                                          padding:
                                                                          EdgeInsets.all(
                                                                              14.0),
                                                                          decoration:
                                                                          BoxDecoration(
                                                                              color: Colors
                                                                                  .white,
                                                                              border:
                                                                              Border(
                                                                                bottom:
                                                                                BorderSide(
                                                                                  width:
                                                                                  2.0,
                                                                                  color: Theme.of(context)
                                                                                      .backgroundColor,
                                                                                ),
                                                                              )),
                                                                          width:
                                                                          MediaQuery.of(
                                                                              context)
                                                                              .size
                                                                              .width,
                                                                          child: Text(
                                                                            snapshot.data![i].itemName!,
                                                                            style: TextStyle(
                                                                                color: Colors
                                                                                    .black,
                                                                                fontSize:
                                                                                12.0),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                            );
                                                          } else {
                                                            return SizedBox.shrink();
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                ],
                                              )
                                            ],
                                          );
                                        }
                                    ),
                                  ),
                                ]),
                          ) : SizedBox.shrink(),
                      ]);}
                ),
              ),
            ),
          )
        ]),
        bottomNavigationBar: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))
            ? SizedBox.shrink()
            : Padding(
          padding: EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: iphonex ? 16.0 : 0.0),
          child: _buildBottomNavigationBar(),
        ),
      ),
    );
  }

   _searchContainermobile() {
    return PreferredSize(
      preferredSize: Size.fromHeight(120),
      child: Container(child:  (Vx.isWeb&&!ResponsiveLayout.isSmallScreen(context))?
      Opacity(
          opacity: 0.0,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.topRight,
                colors:(Vx.isWeb&&!ResponsiveLayout.isSmallScreen(context)) ?[Colors.transparent,Colors.transparent]:[
                  IConstants.isEnterprise?ColorCodes.primaryColor:ColorCodes.whiteColor,
                  IConstants.isEnterprise?ColorCodes.accentColor:ColorCodes.whiteColor
                  /*Theme.of(context).primaryColor,
                  Theme.of(context).accentColor*/
                ],
              ),
            ),
            //color: Theme.of(context).primaryColor,
            width: MediaQuery.of(context).size.width,
            child: Column(children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color:(Vx.isWeb&&!ResponsiveLayout.isSmallScreen(context))?Colors.transparent: Theme.of(context).buttonColor,
                    ),
                    onPressed: () {

                        Navigator.of(context).pop();
                     // Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
                    },
                  ),
                  Text(
                    S .of(context).search_product,//"Search Products",
                    style: TextStyle(color:(Vx.isWeb&&!ResponsiveLayout.isSmallScreen(context))?Colors.transparent: Colors.white, fontSize: 18.0),
                  )
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height:2,

                //padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3.0),
                      border: Border.all(
                          color: (Vx.isWeb&&!ResponsiveLayout.isSmallScreen(context))?Colors.transparent:Colors.grey.withOpacity(0.5), width: 1.0),
                      color:(Vx.isWeb&&!ResponsiveLayout.isSmallScreen(context))?Colors.transparent: ColorCodes.whiteColor,
                    ),
                    child: Row(children: [
                      IconButton(
                        icon: Icon(
                          Icons.search,
                          color:(Vx.isWeb&&!ResponsiveLayout.isSmallScreen(context))?Colors.transparent: Colors.grey,
                        ), onPressed: () {  },
                      ),
                      Container(
                        //margin: EdgeInsets.only(bottom: 30.0),
                          width: MediaQuery.of(context).size.width * 50 / 100,
                          child: TextField(
                              autofocus: true,
                              //controller: (Vx.isWeb)?TextEditingController(text:itemname):null,
                              textInputAction: TextInputAction.search,
                              focusNode: _focus,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                contentPadding:
                                EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
                                hintText: S .of(context).type_to_search_product,//"Type to search products",
                              ),
                              onSubmitted: (value) {
                                searchValue = value;
                                _isShowItem = true;
                                _isLoading = true;
                                // if (Vx.isWeb) onSubmit(itemname);
                                // else{
                                  if(!_issearchloading)
                                    onSubmit(value);
                                  else{
                                    FocusScope.of(context).requestFocus(_focus);
                                  }
                                // }
                              },
                              onChanged: (String newVal) {
                                setState(() {
                                  searchValue = newVal;

                                  if (newVal.length == 0) {
                                    _isSearchShow = false;
                                  } else if (newVal.length == 2) {
                                    //Provider.of<ItemsList>(context,listen: false).fetchsearchItems(newVal);
                                    //search(newVal);
                                  } else if (newVal.length >= 3) {
                                    debugPrint("hello1...");
                                    search(newVal);
                                  }
                                });
                              })),
                    ])),
              ),
            ]),
          )):
      Material(
        elevation: (IConstants.isEnterprise)?0:1,
        child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.topRight,
                colors:[
                  IConstants.isEnterprise?ColorCodes.accentColor:ColorCodes.whiteColor,
                  IConstants.isEnterprise?ColorCodes.primaryColor:ColorCodes.whiteColor
                  /*ColorCodes.accentColor,
                  ColorCodes.primaryColor*/
                ],
              ),
            ),

            //color: Theme.of(context).primaryColor,
            width: MediaQuery.of(context).size.width,
            height: 160.0,
            child: Column(children: <Widget>[
              SizedBox(
                height: 30.0,
              ),
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color:IConstants.isEnterprise?ColorCodes.whiteColor:ColorCodes.blackColor,
                    ),
                    onPressed: () {
                      // Navigator.of(context).pop();
                      // Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
Navigation(context, navigatore: NavigatoreTyp.homenav);
                    },
                  ),
                  Text(
                    S .of(context).search_product,//"Search Products",
                    style: TextStyle(color: IConstants.isEnterprise?ColorCodes.whiteColor:ColorCodes.blackColor, fontSize: 18.0),
                  )
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 40.0,

                //padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3.0),
                      border: Border.all(
                          color: Colors.grey.withOpacity(0.5), width: 1.0),
                      color:(Vx.isWeb&&!ResponsiveLayout.isSmallScreen(context))?Colors.transparent: ColorCodes.whiteColor,
                    ),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.center,children: [
                      IconButton(
                        icon: Icon(
                          Icons.search,
                          color: Colors.grey,
                        ), onPressed: () {  },
                      ),
                      Container(
                        //margin: EdgeInsets.only(bottom: 30.0),
                          width: MediaQuery.of(context).size.width * 80 / 100,
                          child: TextField(
                              autofocus: true,
                              maxLines: 1,
                              //controller: (Vx.isWeb)?TextEditingController(text:itemname):null,
                              textInputAction: TextInputAction.search,
                              focusNode: _focus,

                              //cursorHeight: 20,
                              // style: TextStyle(
                              //   //fontSize: 40.0,
                              //   height: 0.0,
                              //   //color: Colors.black
                              // ),
                              onTap: (){
                                listitem.clear();
                                _isShowItem = false;
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                contentPadding:
                                EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 14.0),
                                hintText: S .of(context).type_to_search_product,//"Type to search products",
                              ),
                              onSubmitted: (value) {
                                //searchValue = value;

                                if (Vx.isWeb) onSubmit(itemname);
                                else{
                                  endOfProduct = false;
                                  if(!_issearchloading)
                                    onSubmit(value);
                                  else{
                                    FocusScope.of(context).requestFocus(_focus);
                                  }
                                }
                              },
                              onChanged: (String newVal) {
                                setState(() {
                                  searchValue = newVal;

                                  if (newVal.length == 0) {
                                    _isSearchShow = false;
                                  } else if (newVal.length == 2) {
                                    //Provider.of<ItemsList>(context,listen: false).fetchsearchItems(newVal);
                                    //search(newVal);
                                  } else if (newVal.length >= 3) {
                                    debugPrint("hello2...");
                                    search(newVal);
                                    /*searchDispaly = searchData.searchitems
                                                        .where((elem) =>
                                                        elem.title
                                                            .toString()
                                                            .toLowerCase()
                                                            .contains(newVal.toLowerCase()))
                                                        .toList();
                                                    _isSearchShow = true;*/
                                  }
                                });
                              })),
                    ])),
              ),
            ])),
      ),),
    );
  }
  Widget _ListSerchItem([AsyncSnapshot<List<ItemData>>? snapshot]) {

    double deviceWidth = MediaQuery.of(context).size.width;
    int widgetsInRow = 1;

    if (deviceWidth > 1200) {
      widgetsInRow = 5;
    } else if (deviceWidth > 768) {
      widgetsInRow = 3;
    }
    double aspectRatio = (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)) ?
    (Features.isSubscription)?(deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 370:
    (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 330 : (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 170;
    if(snapshot==null && listitem.isEmpty) return SizedBox.shrink();
   else{
      //listitem.clear();
     if( snapshot!=null )
      listitem.addAll(snapshot.data!);
      if (listitem.length <= 0) {
        return Container(
          height: MediaQuery
              .of(context)
              .size
              .height * 0.65,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: new Image.asset(
                  Images.noItemImg,
                  fit: BoxFit.fill,
                  height: 250.0,
                  width: 200.0,
//                    fit: BoxFit.cover
                ),
              ),
            ],
          ),
        );//ItemListShimmer();
      }else{
        return  Column(
          children: [
            GridView.builder(
                padding: EdgeInsets.only(top: 10.0),
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: listitem.length,
                gridDelegate:
                new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: widgetsInRow,
                  childAspectRatio: aspectRatio,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return SellingItemsv2("search_item", "", listitem[index],"");
                  // return SellingItems(
                  //   "searchitem_screen",
                  //   snapshot.data[index].id,
                  //   snapshot.data[index].title,
                  //   snapshot.data[index].imageUrl,
                  //   snapshot.data[index].brand,
                  //   "",
                  //   snapshot.data[index].veg_type,
                  //   snapshot.data[index].type,
                  //   snapshot.data[index].eligible_for_express,
                  //   "",
                  //   snapshot.data[index].duration,
                  //   snapshot.data[index].durationType,
                  //   snapshot.data[index].note,
                  //   snapshot.data[index].subscribe,
                  //   snapshot.data[index].paymentmode,
                  //   snapshot.data[index].cronTime,
                  //   snapshot.data[index].name,
                  //
                  // );
                  // return SearchedItems(
                  //   "searchitem_screen",
                  //   snapshot.data[index].id,
                  //   snapshot.data[index].title,
                  //   snapshot.data[index].imageUrl,
                  //   snapshot.data[index].brand,
                  //   "",
                  //   snapshot.data[index].veg_type,
                  //   snapshot.data[index].type,
                  //   snapshot.data[index].eligible_for_express,
                  //  "",
                  //   snapshot.data[index].duration,
                  //   snapshot.data[index].durationType,
                  //   snapshot.data[index].note,
                  //
                  // );
                }),
            if(loading)
              Container(
                height: 50,
                child: Center(
                  child: new CircularProgressIndicator(),
                ),
              ),
            if(endOfProduct) Container(
              decoration: BoxDecoration(
                color: Colors.black12,
              ),
              margin: EdgeInsets.only(top: 10.0),
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(top: 25.0, bottom: 25.0),
              child: Text(
                S.of(context).thats_all_folk,
                // "That's all folks!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            if (Vx.isWeb) Footer(address: PrefUtils.prefs!.getString("restaurant_address")!),
          ],
        );
      }
    }
  }
}