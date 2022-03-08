import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:bachat_mart/repository/productandCategory/category_or_product.dart';
import 'package:bachat_mart/widgets/SliderShimmer.dart';
import 'package:bachat_mart/components/sellingitem_component.dart';
import '../controller/mutations/cat_and_product_mutation.dart';
import '../models/VxModels/VxStore.dart';
import '../models/newmodle/category_modle.dart';
import '../rought_genrator.dart';
import '../widgets/simmers/ItemWeb_shimmer.dart';
import 'package:velocity_x/velocity_x.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/simmers/item_list_shimmer.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../screens/cart_screen.dart';
import '../screens/searchitem_screen.dart';
import '../data/calculations.dart';
import '../assets/images.dart';
import '../widgets/expansion_drawer.dart';
import '../utils/ResponsiveLayout.dart';
import '../widgets/footer.dart';
import '../widgets/header.dart';
import '../assets/ColorCodes.dart';
import '../utils/prefUtils.dart';
import '../constants/IConstants.dart';
import '../constants/features.dart';
import '../generated/l10n.dart';


class ItemsScreen extends StatefulWidget {
  static const routeName = '/items-screen';
  Map<String,String> params;
  ItemsScreen(this.params);
  @override
  _ItemsScreenState createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin,Navigations{
  int startItem = 0;
  bool isLoading = true;
  var load = true;
  bool _initLoad = true;
  // var itemslistData;
  int previndex = -1;
  var subcategoryData;
  ItemScrollController _scrollController = ItemScrollController();
  // ItemScrollController _scrollControllerCategory;
  String subCategoryId = "";
  int subcatType = 0;
  bool _isOnScroll = false;
  String maincategory = "";
  String subcatTitle="";
  // bool _isMaincategoryset = false;
  bool endOfProduct = false;
  bool _checkmembership = false;
  var parentcatid;
  var subcatidinitial;
  String? indvalue;
  ScrollController? _controller;
  MediaQueryData? queryData;
  double? wid;
  double? maxwid;
  String? subcatid;
  String? catId;
  bool iphonex = false;
  int _groupValue = 1;
  ProductController productController = ProductController();
  List<CategoryData> nestedCategory=[];
  var subcatId;
  Future<List<CategoryData>>? _futureNestitem ;

  void Function(VoidCallback fn)? expansionState;

  /// initial == 0 if fetch is initial
  _displayitem(String catid, int index, int type, String initial) {
    print("cat click: $catid");
    setState(() {
      isLoading = true;
      subcatType = type;
      subCategoryId = catid;
    });
    productController.getCategoryprodutlist(catid, initial,type,(isendofproduct){
      setState(() {
        isLoading = false;
        indvalue =  index.toString();
        endOfProduct = false;
      });
    },isexpress: (_groupValue!=1));
  }

  @override
  void initState() {
    print("item screen");
    // _scrollControllerCategory = ItemScrollController();
   initialRoute((){
     Future.delayed(Duration.zero, () async {
       setState(() {
         if (PrefUtils.prefs!.getString("membership") == "1") {
           _checkmembership = true;
         } else {
           _checkmembership = false;
         }
       });
       debugPrint('catId.....'+widget.params['catId'].toString());
       // final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
       subcatId = widget.params['subcatId'];//routeArgs['subcatId'];
       catId = widget.params['catId'].toString();//routeArgs['catId'].toString();
       subcatidinitial= widget.params['subcatId'];//routeArgs['subcatId'];
       subCategoryId=widget.params['subcatId']!;//routeArgs['subcatId'];
       parentcatid=widget.params['catId'].toString();//routeArgs['catId'];
       indvalue = (widget.params['indexvalue']/*routeArgs['indexvalue']*/??"0");
       // Future.delayed(Duration.zero, () async {
       //   _scrollController.jumpTo(
       //     index: int.parse(indvalue!),
       //     /*duration: Duration(seconds: 1)*/
       //   );
       // });
       if (/*routeArgs['prev']*/ widget.params['prev'] == "category_item") {
         maincategory = widget.params['maincategory']!;//routeArgs['maincategory'];
       }
       print("parenytcat: $parentcatid and subcat $subCategoryId");
       _initLoad =false;
       Future.delayed(Duration.zero, () async {
         if((VxState.store as GroceStore).homescreen.data!.allCategoryDetails!.where((element) => element.id==/*routeArgs['catId'].toString()*/widget.params['catId']).length<0) productController.getCategory();
         if((VxState.store as GroceStore).homescreen.data!.allCategoryDetails!.where((element) => element.id==widget.params['catId'].toString()).first.subCategory.where((element) => element.id == /*routeArgs['subcatId']*/widget.params['subcatId'].toString()).isEmpty)
           productController.geSubtCategory(parentcatid,onload: (status){
             final subcategory = (VxState.store as GroceStore).homescreen.data!.allCategoryDetails!.where((element) => element.id==widget.params['catId'].toString()).first.subCategory;
             _displayitem(widget.params['catId'].toString(), subcategory.indexWhere((element) => element.id == widget.params['catId'].toString()),subcategory.where((element) => element.id==widget.params['catId'].toString()).first.type!,"0");
           });
         else
         {
           debugPrint("parentcatid......"+subcatId.toString());
           ProductRepo().getSubNestcategory(subcatId.toString()).then((value) {
             setState(() {
               _futureNestitem = Future.value(value);
               debugPrint(_futureNestitem.toString());
             });
             _displayitem(subcatId.toString(), int.parse("0"),0,"0");
           });
    /*       productController.getNestedCategory(parentcatid,(isexist){
             if(isexist) indvalue = "1";
             setState(() {
               _futureNestitem = productController.getNestedCategory(parentcatid, (p0) => null);
               debugPrint("list of nest"+_futureNestitem.toString());
             });
           });*/
         }
       });
     });
   });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget itemsWidget() {


    double deviceWidth = MediaQuery.of(context).size.width;
    int widgetsInRow =  (kIsWeb && !ResponsiveLayout.isSmallScreen(context)) ? 2 : 1;

    if (deviceWidth > 1200) {
      widgetsInRow = 5;
    } else if (deviceWidth > 768) {
      widgetsInRow = 3;
    }
    double aspectRatio =   (kIsWeb && !ResponsiveLayout.isSmallScreen(context))?
    (Features.isSubscription)?(deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 460:
    (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 410 :
    (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 190;
    // do {
    //   setState(() {
    //     (_groupValue == 1) ?
    //     startItem = itemslistData.items.length ?? 0 :
    //     startItem = itemslistData.length ?? 0
    //     ;
    //   });
    //   Provider.of<ItemsList>(context, listen: false)
    //       .fetchItems(
    //       subCategoryId,
    //       subcatType,
    //       startItem,
    //       "scrolling")
    //       .then((_) {
    //     setState(() {
    //       // startItem = itemslistData.items.length;
    //       debugPrint("startItem........"+subCategoryId.toString()+"  "+startItem.toString());
    //      // itemslistData = Provider.of<ItemsList>(context, listen: false);
    //       if (_groupValue == 1){
    //         itemslistData = Provider.of<ItemsList>(context, listen: false);
    //       }else{
    //         itemslistData = Provider.of<ItemsList>(context, listen: false).findByIdExpress();
    //       }
    //     });
    //     if (PrefUtils.prefs
    //         .getBool("endOfProduct")) {
    //       setState(() {
    //         startItem = 0;
    //         _isOnScroll = false;
    //         endOfProduct = true;
    //       });
    //     } else {
    //       setState(() {
    //         _isOnScroll = false;
    //         endOfProduct = false;
    //       });
    //
    //     }
    //   });
    // }while(PrefUtils.prefs!.getBool("endOfProduct"));

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Divider(),
        // SizedBox(height: 15,),
        VxBuilder(
          mutations: {ProductMutation},
          builder: (ctx,GroceStore? store,VxStatus? state){
            //load = false;
            nestedCategory = store!.homescreen.data!.allCategoryDetails!.where((element) => element.id == parentcatid).first.subCategory;
            final productlist = store.productlist;
            return    (isLoading) ?
            Center(
              child: (kIsWeb && !ResponsiveLayout.isSmallScreen(context))
                  ? ItemListShimmerWeb()
                  : ItemListShimmer(), //CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),

            ) :
            /* _checkitem*/(productlist.length>0)
                ? ResponsiveLayout.isExtraLargeScreen(context) ?
            Column(
              children: <Widget>[

                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GridView.builder(
                      shrinkWrap: true,
                      // controller: new ScrollController(keepScrollOffset:true,initialScrollOffset: 10),
                      itemCount: productlist.length,/*(_groupValue == 1)
                           ? *//*itemslistData.items.length*//*productlist.length
                           : itemslistData.length,*/
                      gridDelegate:
                      new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: widgetsInRow,
                        crossAxisSpacing: 3,
                        childAspectRatio: aspectRatio,
                      ),
                      itemBuilder:
                          (BuildContext context,
                          int index) {
                        final routeArgs =
                        ModalRoute
                            .of(context)!
                            .settings
                            .arguments as Map<String, dynamic>;
                        print("data to singel product1: ${{
                          'maincategory': widget.params['maincategory'],
                          'catId': widget.params['catId'],
                          'catTitle': widget.params['catTitle'],
                          'subcatId': subcatId,
                          'indexvalue': widget.params['indexvalue'],
                          'prev': widget.params['prev'],
                        }.toString()}");
                        return /*(_groupValue == 1) ?*/
                          SellingItemsv2(
                            "item_screen",
                            "",//itemslistData.items[index].id,
                            productlist[index],
                            "",
                            returnparm: {
                              'maincategory': widget.params['maincategory']!,
                              'catId': catId!,
                              'catTitle': widget.params['catTitle']!,
                              'subcatId': subcatId,
                              'indexvalue': widget.params['indexvalue']!,
                              'prev': widget.params['prev']!,
                            },
                          ) ;
                        /*      :
                         SellingItems(
                           "item_screen",
                           itemslistData[index].id,
                           itemslistData[index].title,
                           itemslistData[index].imageUrl,
                           itemslistData[index].brand,
                           "",
                           itemslistData[index].veg_type,
                           itemslistData[index].type,
                           itemslistData[index].eligible_for_express,
                           itemslistData[index].delivery,
                           itemslistData[index].duration,
                           itemslistData[index].durationType,
                           itemslistData[index].note,
                           itemslistData[index].subscribe,
                           itemslistData[index].paymentmode,
                           itemslistData[index].cronTime,
                           itemslistData[index].name,

                           returnparm: {
                             'maincategory': routeArgs['maincategory'],
                             'catId': routeArgs['catId'],
                             'catTitle': routeArgs['catTitle'],
                             'subcatId': subcatId,
                             'indexvalue': routeArgs['indexvalue'],
                             'prev': routeArgs['prev'],
                           },
                         );*/
                      }),
                ),
                if (endOfProduct)
                  Container(
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
                      S.of(context).thats_all_folk,
                      // "That's all folks!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
              ],
            )
                : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  if(!Vx.isWeb)
                    if(nestedCategory[int.parse(indvalue!)].banner!=null&&nestedCategory[int.parse(indvalue!)].banner!="")
                      CachedNetworkImage(
                          imageUrl: nestedCategory[int.parse(indvalue!)].banner??"",
                          placeholder: (context, url) {
                            return SliderShimmer().sliderShimmer(context, height: 180);
                          },
                          errorWidget: (context, url, error) => Image.asset(Images.defaultSliderImg),
                          fit: BoxFit.fitWidth),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child:
                    GridView.builder(
                        shrinkWrap: true,
                        controller: new ScrollController(
                            keepScrollOffset: false),
                        itemCount: /*(_groupValue == 1) ? itemslistData.items
                               .length : itemslistData.length*/productlist.length,
                        gridDelegate:
                        new SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: widgetsInRow,
                          crossAxisSpacing: 3,
                          childAspectRatio: aspectRatio,
                          mainAxisSpacing: 3,
                        ),
                        itemBuilder:
                            (BuildContext context,
                            int index) {

                          print("data to singel product3: ${{
                            'maincategory': maincategory,
                            'catId': catId,
                            'catTitle': subcatTitle,
                            'subcatId': subcatId,
                            'indexvalue': index.toString(),
                            'prev': widget.params['prev'],
                          }.toString()}");
                          /* return (_groupValue == 1) ?*/ return SellingItemsv2(
                            "item_screen",
                            "",
                            productlist[index],
                            "",
                            returnparm: {
                              'maincategory': maincategory,
                              'catId': catId!,
                              'catTitle': subcatTitle,
                              'subcatId': subcatId,
                              'indexvalue': index.toString(),
                              'prev': widget.params['prev'].toString(),
                            },
                          ) ;
                        }),

                  ),
                  if (endOfProduct)
                    Container(
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
                    ),
                ],
              ),
            )
                : Container(
              height: MediaQuery.of(context).size.height /1.5,
              child: Center(
                child: new Image.asset(
                  Images.noItemImg,
                  fit: BoxFit.fill,
                  height: 250.0,
                  width: 200.0,
//                    fit: BoxFit.cover
                ),
              ),
            );
          },
        ),

        if(!kIsWeb) Container(
          height: _isOnScroll ? 50 : 0,
          child: Center(
            child: new CircularProgressIndicator(),
          ),
        ),
        //if(kIsWeb && ResponsiveLayout.isSmallScreen(context)) Footer(address: PrefUtils.prefs!.getString("restaurant_address")),
      ],
    );
  }

  // _displayCategory(String subcatId) {
  //   Provider.of<CategoriesItemsList>(context, listen: false).fetchNestedCategory(subcatId, "itemScreen").then((_) {
  //     setState(() {
  //       subcategoryData = Provider.of<CategoriesItemsList>(context, listen: false,);
  //       int index = 0;
  //       String subcatid;
  //       int count = 0;
  //       for (int i = 0; i < subcategoryData.itemNested.length; i++) {
  //         if (subcategoryData.itemNested[i].catid == subcatId) {
  //           count++;
  //           index = i;
  //           subcatid = subcategoryData.itemNested[index].catid;
  //           subCategoryId = subcategoryData.itemNested[index].catid;
  //           subcatType = subcategoryData.itemNested[index].type;
  //         } else {
  //         }
  //       }
  //       for (int i = 0; i < subcategoryData.itemNested.length; i++) {
  //         if (i != index) {
  //           subcategoryData.itemNested[i].boxbackcolor = Colors.transparent;
  //           subcategoryData.itemNested[i].boxsidecolor = Colors.black54;
  //           subcategoryData.itemNested[i].textcolor = Colors.black54;
  //         } else {
  //           subcategoryData.itemNested[i].boxbackcolor = Colors.transparent;
  //           subcategoryData.itemNested[i].boxsidecolor = ColorCodes.greenColor;
  //           subcategoryData.itemNested[i].textcolor = ColorCodes.greenColor;
  //         }
  //       }
  //       _initLoad = false;
  //       startItem = 0;
  //       // itembloc.fetchitems(subcatid, subcatType, startItem, "initialy");
  //       Future.delayed(Duration.zero, () async {
  //         _scrollController.jumpTo(
  //           index: index,
  //           /*duration: Duration(seconds: 1)*/
  //         );
  //       });
  //     });
  //   });
  // }

  Widget _myRadioButton({int? value, Function(int)? onChanged}) {
    //prefs.setString('fixtime', timeslotsData[_groupValue].time);
    return Radio<int>(
      activeColor: Theme.of(context).primaryColor,
      value: value!,
      groupValue: _groupValue,
      onChanged:(int) =>onChanged,
    );
  }

  _dialogsetExpress() async{
    Navigator.of(context).pop(true);
    setState(() {
      load = false;
    });

  }

  ShowpopupForRadioButton(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            child: Container(
              height: 200,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 5,),
                  Container(
                    child: Text(S.current.select_option, style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                  ),
                  SizedBox(height: 10,),
                  ListTile(
                    dense: true,
                    leading:  Container(

                      child: _myRadioButton(
                        value: 1,
                        onChanged: (newValue) {
                          setState(() {
                            _groupValue = newValue;
                            setState(() {
                              load = true;

                              _dialogsetExpress();
                            });
                          });
                        },
                      ),
                    ),
                    contentPadding: EdgeInsets.all(0.0),
                    title:  Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 50 /100,
                          child: Text(
                              S.current.all_product,
                              style: TextStyle(
                                  color: ColorCodes.blackColor,
                                  fontSize: 16, fontWeight: FontWeight.bold
                              )
                          ),
                        ),

                      ],
                    ),
                  ),
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.all(0.0),
                    leading: Container(
                      child: _myRadioButton(
                        value: 2,
                        onChanged: (newValue) {
                          setState(() {
                            _groupValue = newValue;
                            setState(() {
                              load = true;

                              _dialogsetExpress();

                            });
                          });
                        },
                      ),
                    ),
                    title:
                    Row(
                      children: [
                        Container(

                          child: Text(
                              S.current.express_delivery,
                              style: TextStyle(
                                  color: ColorCodes.blackColor,
                                  fontSize: 16, fontWeight: FontWeight.bold
                              )
                          ),
                        ),

                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          child: Text(S.current.cancel, style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),),
                        ),
                      ),
                      SizedBox(width: 20,),
                    ],
                  ),
                  SizedBox(height: 10,),
                ],
              ),
            ),
          );
        });

      },
    );
  }

  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    wid= queryData!.size.width;
    maxwid=wid!*0.90;
    _buildBottomNavigationBar() {
      return BottomNaviagation(
        itemCount: CartCalculations.itemCount.toString() + " " + S.of(context).items,
        title: S.current.view_cart,
        total: _checkmembership ? (CartCalculations.totalMember).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)
            :
        (CartCalculations.total).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
        onPressed: (){
          setState(() {
         /*   Navigator.of(context)
                .pushNamed(CartScreen.routeName, arguments: {
              "after_login": ""
            });*/
            Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
          });
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
    PreferredSizeWidget _appBarMobile() {
      return AppBar(
        //toolbarHeight: 60.0,
        elevation: (IConstants.isEnterprise)?0:1,
        automaticallyImplyLeading: false,
        title: Text(maincategory,style: TextStyle(color:IConstants.isEnterprise?ColorCodes.menuColor:ColorCodes.blackColor ),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: IConstants.isEnterprise?ColorCodes.menuColor:ColorCodes.blackColor),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          GestureDetector(
              onTap: (){
                ShowpopupForRadioButton(context);
              },
              child: Container(
                width: 80,
                // height: 20,
                margin: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.white),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.filter_alt_outlined),
                    Text('Filters'),
                  ],
                ),
              )),
          SizedBox(width: 10),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                Navigation(context, navigatore: NavigatoreTyp.Push,name: Routename.search);
              },
              child: Container(
                margin: EdgeInsets.only(top: 15, right: 10, bottom: 15),
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                ),

                child: Icon(
                  Icons.search,
                  color: IConstants.isEnterprise?ColorCodes.whiteColor:ColorCodes.blackColor,
                  size: 20,
                ),
              ),
            ),
          ),
          /*  ValueListenableBuilder(
                valueListenable: Hive.box<Product>(productBoxName).listenable(),
                builder: (context, Box<Product> box, index) {
                  if (box.values.isEmpty)
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(CartScreen.routeName);
                      },
                      child:  Container(
                        margin: EdgeInsets.only(top: 15, right: 10, bottom: 15),
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Theme.of(context).buttonColor),

                        child: Icon(
                          Icons.shopping_cart_outlined,
                          size: 17,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    );
                  int cartCount = 0;
                  for (int i = 0;
                  i < Hive.box<Product>(productBoxName).length;
                  i++) {
                    cartCount = cartCount +
                        Hive.box<Product>(productBoxName)
                            .values
                            .elementAt(i)
                            .itemQty;
                  }
                  return Consumer<Calculations>(
                    builder: (_, cart, ch) => Badge(
                      child: ch,
                      color: Colors.green,
                      value: cartCount.toString(),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(CartScreen.routeName);
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 15, right: 10, bottom: 15),
                        width: 25,
                        height: 25,
                        //margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Theme.of(context).buttonColor),

                        child: Icon(
                            Icons.shopping_cart_outlined,
                            color: Theme.of(context).primaryColor,
                            size: 17
                        ),
                      ),
                    ),
                  );
                },
              ),*/
          SizedBox(width: 10),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    IConstants.isEnterprise?ColorCodes.accentColor:ColorCodes.whiteColor,
                    IConstants.isEnterprise?ColorCodes.primaryColor:ColorCodes.whiteColor
                  ])
          ),
        ),
      )

      /*  Container(
          decoration: BoxDecoration(
          boxShadow: [
          BoxShadow(
          color: ColorCodes.grey.withOpacity(0.3),
          spreadRadius: 3,
          blurRadius: 5,
          offset: Offset(0, 3),
         )
        ],
      gradient: LinearGradient(
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
      colors: [
          ColorCodes.accentColor,
          ColorCodes.primaryColor
         ],
        ),
      ),
      //color: Theme.of(context).primaryColor,
      height: 120,
      child:Column(
      children: [
        Row(
          children: <Widget>[
            IconButton(
              padding: EdgeInsets.only(left: 0.0),
              icon: Icon(
                Icons.arrow_back,
                color: IConstants.isEnterprise ? ColorCodes.menuColor : ColorCodes.darkgreen,
                size: IConstants.isEnterprise ? 25.0 : 30,
              ),
              onPressed: () {
               // HomeScreen.scaffoldKey.currentState.openDrawer();
                Navigator.of(context).pop();
              },
            ),
            SizedBox(width: 10,),
            Text(maincategory,style: TextStyle(color:ColorCodes.menuColor )),
            Spacer(),
            SizedBox(
              width: 10,
            ),
            SizedBox(width: 5),
          ],
        ),
       ],
      ))*/;
    }
    Widget _body(){
      return _initLoad
          ? Center(child: (kIsWeb && !ResponsiveLayout.isSmallScreen(context))?ItemListShimmerWeb():ItemListShimmer(),)
          :  itemsWidget();
    }

    _bodyweb(){
      print(" sub cate for web: $subcatidinitial and parentcat $parentcatid");
      return
        NotificationListener<
            ScrollNotification>(
          // ignore: missing_return
          onNotification:
              (ScrollNotification scrollInfo) {
            if (!endOfProduct) if (!_isOnScroll &&
                // ignore: missing_return
                scrollInfo.metrics.pixels ==
                    scrollInfo
                        .metrics.maxScrollExtent) {
              setState(() {
                _isOnScroll = true;
              });
              productController.getCategoryprodutlist(subCategoryId, (VxState.store as GroceStore).productlist.length,subcatType,(isendofproduct){
                endOfProduct = isendofproduct;
                if(endOfProduct){

                  setState(() {
                    isLoading = false;
                    _isOnScroll = false;
                    endOfProduct = true;
                  });
                }else {
                  setState(() {
                    isLoading = false;
                    _isOnScroll = false;
                    endOfProduct = false;

                  });
                }
              },isexpress: _groupValue==1?false:true);
              /*     Provider.of<ItemsList>(context, listen: false)
                  .fetchItems(
                  subCategoryId,
                  subcatType,
                  startItem,
                  "scrolling")
                  .then((_) {
                setState(() {
                  //itemslistData = Provider.of<ItemsList>(context, listen: false);
                  startItem = itemslistData.items.length;
                  if (PrefUtils.prefs
                      .getBool("endOfProduct")) {
                    _isOnScroll = false;
                    endOfProduct = true;
                  } else {
                    _isOnScroll = false;
                    endOfProduct = false;
                  }
                });
              });*/

              // start loading data
              setState(() {
                isLoading = false;
              });
            }
            return true;
          },
          child: SingleChildScrollView(
              child:
              Column(
                children: [
                  if(kIsWeb && !ResponsiveLayout.isSmallScreen(context))
                    Header(false,onSubcatClick: (catid,subcatid,type,index){
                      setState(() {
                        indvalue = index.toString();
                        parentcatid = catid;
                        subcatidinitial = subcatid;
                      });
                      // expansionState((){
                      //   indvalue = index.toString();
                      //   parentcatid = catid;
                      //   subcatidinitial = subcatid;
                      // });
                      _displayitem(subcatid, index,type,"0");
                    },),
                  /* if(isLoading)*/ Container(
                    padding: EdgeInsets.only(left:(kIsWeb&& !ResponsiveLayout.isSmallScreen(context))?28:0 ),
                    //constraints: BoxConstraints(maxWidth: 1200),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [

                        if(kIsWeb && !ResponsiveLayout.isSmallScreen(context))
                          if(subcatidinitial!=null&& parentcatid!=null)
                            ExpansionDrawer(parentcatid,subcatidinitial,onclick:(catid,type,index){
                              _displayitem(catid,index,type,"0");
                            }),
                        SizedBox(width: 15,),
                        Flexible(
                            child:
                            _body()
                        ),
                      ],
                    ),
                  ),
                  // ),
                  if (kIsWeb) Footer(address: PrefUtils.prefs!.getString("restaurant_address")!),
                ],
              )
          ),
        );
    }

    return Scaffold(
      appBar: ResponsiveLayout.isSmallScreen(context) ?_appBarMobile():PreferredSize(preferredSize: Size.fromHeight(0),child: SizedBox.shrink()),
      backgroundColor: ColorCodes.whiteColor,
      body:
      (kIsWeb )?
      _bodyweb():
      Column(
        children: [
          if(!kIsWeb)
            FutureBuilder(
                future: /*{ProductMutation}*/_futureNestitem,
                builder: (BuildContext context, AsyncSnapshot<List<CategoryData>> snapshot) {
                  // nestedCategory.clear();
                  // CategoryData data = store.homescreen.data.allCategoryDetails
                  //     .where((element) => element.id == parentcatid).length>0?store.homescreen.data.allCategoryDetails
                  //     .where((element) => element.id == parentcatid)
                  //     .first:store.homescreen.data.allCategoryDetails[0];
                  // final subCategoryData = ;
                  // final subcatdata = productController.geSubtCategory(catId);
                  // subnestdata = productController.getNestedCategory(parentcatid, catId);
                  parentcatid=widget.params['catId'].toString();
                 // nestedCategory = snapshot.data;
                  //debugPrint("futurelist......"+snapshot.data.length.toString());
                  /*store!.homescreen.data!.allCategoryDetails!.where((element) {
                    print("${element.id}==$parentcatid");
                    return element.id == parentcatid;
                  }).first.subNestCategory;*/
                  if( snapshot.data!=null) {
                    debugPrint("length,,,,,,,,,,,,,,,"+snapshot.data!.length.toString());
                    //
                    // if (nestedCategory == null && nestedCategory.length <= 0) {
                    //   nestedCategory = store.homescreen.data.allCategoryDetails
                    //       .where((element) => element.id == catId)
                    //       .first
                    //       .subCategory;
                    // }
                    return isLoading?SizedBox.shrink():Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 15),
                          color: Colors.white,
                          child: SizedBox(
                            height: 60,
                            child: ScrollablePositionedList.builder(
                              itemScrollController: _scrollController,
                              scrollDirection: Axis.horizontal,
                              itemCount:
                              /*nestedCategory.length*/ snapshot.data!.length,
                              itemBuilder: (_, i) => Column(
                                children: [
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onTap: () {


                                        print("display:" +  snapshot.data![i].id!);
                                        _displayitem( snapshot.data![i].id!, i, snapshot.data![i].type!,"0");
                                      },
                                      child: Container(
                                        height: 45,
                                        margin:
                                        EdgeInsets.only(left: 5.0, right: 5.0),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(6),
                                            border: Border.all(
                                              width: 1.0,
                                              color: i.toString() !=indvalue.toString()? ColorCodes.grey:ColorCodes.greenColor /*snapshot.data[i]
                                                     .boxsidecolor ?? Colors.black54*/
                                              ,
                                              /* bottom: BorderSide(
                                          width: 2.0,
                                          color: snapshot.data[i].boxsidecolor??Colors.transparent,
                                        ),*/
                                            )),
                                        child: Padding(
                                          padding:
                                          EdgeInsets.only(left: 5.0, right: 5.0),
                                          child: Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: <Widget>[
                                              CachedNetworkImage(
                                                imageUrl:  snapshot.data![i].iconImage,
                                                placeholder: (context, url) =>
                                                    Image.asset(
                                                      Images.defaultCategoryImg,
                                                      height: 40,
                                                      width: 40,
                                                    ),
                                                errorWidget: (context, url, error) =>
                                                    Image.asset(
                                                      Images.defaultCategoryImg,
                                                      width: 40,
                                                      height: 40,
                                                    ),
                                                height: 40,
                                                width: 40,
                                                fit: BoxFit.cover,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                snapshot.data![i].categoryName!,
//                            textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight: /*snapshot.data[i]
                                                           .fontweight*/
                                                    FontWeight.bold,
                                                    color:(i.toString() !=indvalue.toString())? ColorCodes.grey:ColorCodes.greenColor),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                ],
                              ),
                            ),
                            // else if (snapshot.hasError)
                            //   return SizedBox.shrink();
                            // else
                            //   return SizedBox.shrink();
                            //   },
                            // ),
                          ),
                        ),

                      ],
                    );
                  }
                  else{
                    return SizedBox.shrink();
                  }
                }
            ),
          Expanded(
            child: NotificationListener<
                ScrollNotification>(
              // ignore: missing_return
                onNotification:
                    (ScrollNotification scrollInfo) {
                  if (!endOfProduct) if (!_isOnScroll &&
                      // ignore: missing_return
                      scrollInfo.metrics.pixels ==
                          scrollInfo
                              .metrics.maxScrollExtent) {

                    setState(() {
                      _isOnScroll = true;
                    });
                    productController.getCategoryprodutlist(subCategoryId, (VxState.store as GroceStore).productlist.length,subcatType,(isendofproduct){
                      startItem = (VxState.store as GroceStore).productlist.length;
                      endOfProduct = isendofproduct;
                      if(endOfProduct){
                        print("endof product");
                        setState(() {
                          _isOnScroll = false;
                          endOfProduct = true;
                        });
                      }else {
                        setState(() {
                          _isOnScroll = false;
                          endOfProduct = false;
                        });

                      }
                    },isexpress: _groupValue==1?false:true);
                    /*   Provider.of<ItemsList>(context, listen: false)
                            .fetchItems(
                            subCategoryId,
                            subcatType,
                            startItem,
                            "scrolling")
                            .then((_) {
                          setState(() {
                            //itemslistData = Provider.of<ItemsList>(context, listen: false);
                            startItem = itemslistData.items.length;
                            if (PrefUtils.prefs
                                .getBool("endOfProduct")) {
                              _isOnScroll = false;
                              endOfProduct = true;
                            } else {
                              _isOnScroll = false;
                              endOfProduct = false;
                            }
                          });
                        });*/

                    // start loading data
                    setState(() {
                      isLoading = false;
                    });
                  }
                  return true;
                },child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: _body())),
          ),
        ],
      ),
      bottomNavigationBar:  kIsWeb ? SizedBox.shrink() :Container(
        color: Colors.white,
        child: Padding(
            padding: EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: iphonex ? 16.0 : 0.0),
            child: _buildBottomNavigationBar()
        ),
      ),
    );
  }

}