import '../../constants/features.dart';
import '../../controller/mutations/cart_mutation.dart';
import '../../models/VxModels/VxStore.dart';
import '../../models/newmodle/cartModle.dart';
import 'package:velocity_x/velocity_x.dart';
import '../assets/ColorCodes.dart';
import '../generated/l10n.dart';
import '../constants/IConstants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../assets/images.dart';
import '../utils/prefUtils.dart';

class CartitemsDisplay extends StatefulWidget {

  Function? isdbonprocess ;
  var onempty;
  CartItem snapshot;

  CartitemsDisplay(this.snapshot,
      {this.onempty});

  @override
  _CartitemsDisplayState createState() => _CartitemsDisplayState();
}

class _CartitemsDisplayState extends State<CartitemsDisplay> {
  bool _isAddToCart = false;
  var checkmembership = false;
  String _itemPrice = "";
  bool _checkMembership = false;
  bool _isLoading = true;
  bool iphonex = false;
  bool _isaddOn = false;

  @override
  void initState() {

    Future.delayed(Duration.zero, () async {
    if(widget.snapshot.addOn.toString() == "0"){
      _isaddOn = true;
    }
    else{
      _isaddOn = false;
    }
  });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // if (widget.snapshot.mode == "1") {
    //   checkmembership = true;
    // } else {
    //   checkmembership = false;
    // }

    if (!_isLoading)
      if ((VxState.store as GroceStore).userData.membership == "1") {
      _checkMembership = true;
    } else {
      _checkMembership = false;
    }

    
    if (_checkMembership) {
      if (widget.snapshot.membershipPrice == '-' || widget.snapshot.membershipPrice == "0") {
        if (double.parse(widget.snapshot.price!) <= 0 ||
            widget.snapshot.price.toString() == "") {
          _itemPrice = widget.snapshot.varMrp!;
        } else {
          _itemPrice = widget.snapshot.price!;
        }
      } else {
        _itemPrice = widget.snapshot.membershipPrice!;
      }
    } else {
      if (double.parse(widget.snapshot.price!) <= 0 ||
          widget.snapshot.price.toString() == "") {
        _itemPrice = widget.snapshot.varMrp!;
      } else {
        _itemPrice = widget.snapshot.price!;
      }
    }

    updateCart(int qty,CartStatus cart,String varid){
      switch(cart){

        case CartStatus.increment:
          cartcontroller.update((done){
            setState(() {
              _isAddToCart = !done;
            });
          },price: widget.snapshot.price.toString(),quantity:( qty+1).toString(),var_id: varid);
          // TODO: Handle this case.
          break;
        case CartStatus.remove:
          cartcontroller.update((done){
            setState(() {
              _isAddToCart = !done;
            });
          },price: widget.snapshot.price.toString(),quantity:"0",var_id: varid);
          // TODO: Handle this case.
          break;
        case CartStatus.decrement:
          cartcontroller.update((done){
            setState(() {
              _isAddToCart = !done;
            });
          },price: widget.snapshot.price.toString(),quantity:((qty)<= int.parse(widget.snapshot.varMinItem!))?"0":(qty-1).toString(),var_id: varid);
          // TODO: Handle this case.
          break;
      }
    }
    return
      //_isaddOn?
      Container(
     // color: Colors.white,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12)
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10),
        child: Row(
          children: <Widget>[
            (widget.snapshot.mode == "1")
                ? Image.asset(
              Images.membershipImg,
              width: 80,
              height: 80,
              color: Theme
                  .of(context)
                  .primaryColor,
            )
                : Container(
              width: 100,
              height: 100,
              child: FadeInImage(
                image: NetworkImage(widget.snapshot.itemImage??""),
                placeholder: AssetImage(
                  Images.defaultProductImg,
                ),
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //SizedBox(height: 10,),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.snapshot.itemName!,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              // cartBloc.cartItems();
                              updateCart(int.parse(widget.snapshot.quantity!), CartStatus.remove, widget.snapshot.varId.toString());
                              if(widget.snapshot.mode == "1"){
                                PrefUtils.prefs!.setString("memberback", "no");
                              }else{
                                PrefUtils.prefs!.setString("memberback", "");
                              }
                            },
                          child:Image.asset(
                            Images.Delete,
                            height: 22.0,
                          )),
                          SizedBox(
                            width: 10,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Text(
                                widget.snapshot.varName!,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: ColorCodes.greenColor),
                              )),
                          SizedBox(
                            width: 10,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text((double.parse(widget.snapshot.quantity!) == 0 || widget.snapshot.status.toString() == "0") ?
                              Features.iscurrencyformatalign?
                              IConstants.numberFormat == "1"?' ' + (double.parse(_itemPrice)*(double.parse(widget.snapshot.quantity!))).toStringAsFixed(0)  + ' ' + IConstants.currencyFormat:
                              ' ' + (double.parse(_itemPrice)*(double.parse(widget.snapshot.quantity!))).toStringAsFixed(IConstants.decimaldigit)  + ' ' + IConstants.currencyFormat:
                          IConstants.numberFormat == "1"?IConstants.currencyFormat + ' ' + ' ' + (double.parse(_itemPrice)*(double.parse(widget.snapshot.quantity!))).toStringAsFixed(0):
                          IConstants.currencyFormat + ' ' + ' ' + (double.parse(_itemPrice)*(double.parse(widget.snapshot.quantity!))).toStringAsFixed(IConstants.decimaldigit)
                              :
                              Features.iscurrencyformatalign?
                              IConstants.numberFormat == "1"?' ' + (double.parse(_itemPrice)*(double.parse(widget.snapshot.quantity!))).toStringAsFixed(0) + ' ' + IConstants.currencyFormat:' ' + (double.parse(_itemPrice)*(double.parse(widget.snapshot.quantity!))).toStringAsFixed(IConstants.decimaldigit)  + ' ' +  IConstants.currencyFormat:
                          IConstants.numberFormat == "1"?IConstants.currencyFormat + ' ' + ' ' + (double.parse(_itemPrice)*(double.parse(widget.snapshot.quantity!))).toStringAsFixed(0):IConstants.currencyFormat + ' ' + ' ' + (double.parse(_itemPrice)*(double.parse(widget.snapshot.quantity!))).toStringAsFixed(IConstants.decimaldigit),
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16)),
                          Spacer(),

                          // SizedBox(
                          //   width: 5,
                          // ),
                          (double.parse(widget.snapshot.varStock!) == 0 || widget.snapshot.status == "1") ? Text(
                            double.parse(widget.snapshot.varStock!) == 0 ? S .of(context).out_of_stock/*"Out Of Stock"*/ : S .of(context).unavailable,/*"Unavailable"*/
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.red),
                          )
                              :
                          VxBuilder(builder: (context,GroceStore store,state){
                            final box = store.CartItemList;
                            if(box.isNotEmpty){
                              if(box.isNotEmpty){

                                return Row(
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () async {
                                        if (int.parse(widget.snapshot.quantity!) <= int.parse(widget.snapshot.varMinItem!)) {
                                          setState(() {
                                           updateCart(int.parse(widget.snapshot.quantity!), CartStatus.decrement, widget.snapshot.varId.toString());

                                          });
                                        } else {
                                          setState(() {
                                           updateCart(int.parse(widget.snapshot.quantity!), CartStatus.decrement, widget.snapshot.varId.toString());
                                          });
                                        }
                                        if(widget.snapshot.mode == "1"){
                                          PrefUtils.prefs!.setString("memberback", "no");
                                        }else{
                                          PrefUtils.prefs!.setString("memberback", "");
                                        }
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                            color: IConstants.isEnterprise?ColorCodes.greenColor:ColorCodes.maphome,
                                            border: Border(
                                              top: BorderSide(
                                                  width: 1.0, color: IConstants.isEnterprise?ColorCodes.greenColor:ColorCodes.maphome),
                                              bottom: BorderSide(
                                                  width: 1.0, color: IConstants.isEnterprise?ColorCodes.greenColor:ColorCodes.maphome),
                                              left: BorderSide(
                                                  width: 1.0, color: IConstants.isEnterprise?ColorCodes.greenColor:ColorCodes.maphome),
                                            ),
                                          ),
                                          width: 30,
                                          height: 25,
                                          child: Center(
                                            child: Text(
                                              "-",
                                              textAlign: TextAlign.center,
                                              style:
                                              TextStyle(color: ColorCodes.whiteColor),
                                            ),
                                          )),
                                    ),
                                    _isAddToCart ?
                                    Container(
                                      width: 35,
                                      height: 25,
                                      padding: EdgeInsets.only(left: 7.5, top: 2.5, right: 7.5, bottom: 2.5),
                                      child: SizedBox(
                                          width: 20.0,
                                          height: 20.0,
                                          child: new CircularProgressIndicator(
                                            strokeWidth: 2.0,
                                            valueColor: new AlwaysStoppedAnimation<Color>(IConstants.isEnterprise?ColorCodes.greenColor:ColorCodes.maphome),)),
                                    )
                                        :
                                    Container(
                                        width: 35,
                                        height: 25,
                                        decoration: BoxDecoration(
                                          border: Border(
                                            top: BorderSide(
                                                width: 1.0, color: IConstants.isEnterprise?ColorCodes.greenColor:ColorCodes.maphome),
                                            bottom: BorderSide(
                                                width: 1.0, color: IConstants.isEnterprise?ColorCodes.greenColor:ColorCodes.maphome),
                                            left: BorderSide(
                                                width: 1.0, color: IConstants.isEnterprise?ColorCodes.greenColor:ColorCodes.maphome),
                                            right: BorderSide(
                                                width: 1.0, color: IConstants.isEnterprise?ColorCodes.greenColor:ColorCodes.maphome),
                                          ),
                                        ),
                                        // decoration: BoxDecoration(color: Colors.green,border: Border.),
                                        child: Center(
                                          child: Text(
                                            widget.snapshot.quantity.toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Theme.of(context).primaryColor,
                                            ),
                                          ),
                                        )),
                                    GestureDetector(
                                      onTap: () {
                                        if (double.parse(widget.snapshot.quantity!) < double.parse(widget.snapshot.varStock!)) {
                                          if (double.parse(widget.snapshot.quantity!) < int.parse(widget.snapshot.varMaxItem!)) {

                                            updateCart(int.parse(widget.snapshot.quantity!), CartStatus.increment, widget.snapshot.varId!);
                                          } else {
                                            Fluttertoast.showToast(
                                                msg:
                                                S .of(context).cant_add_more_item,//"Sorry, you can\'t add more of this item!",
                                                fontSize: MediaQuery.of(context).textScaleFactor *13,
                                                backgroundColor: Colors.black87,
                                                textColor: Colors.white);
                                          }
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: S .of(context).sorry_outofstock,//"Sorry, Out of Stock!",
                                              fontSize: MediaQuery.of(context).textScaleFactor *13,
                                              backgroundColor: Colors.black87,
                                              textColor: Colors.white);
                                        }
                                      },
                                      child: Container(
                                          width: 30,
                                          height: 25,
                                          decoration: BoxDecoration(
                                            color: IConstants.isEnterprise?ColorCodes.greenColor:ColorCodes.maphome,
                                            border: Border(
                                              top: BorderSide(
                                                  width: 1.0, color: IConstants.isEnterprise?ColorCodes.greenColor:ColorCodes.maphome),
                                              bottom: BorderSide(
                                                  width: 1.0, color: IConstants.isEnterprise?ColorCodes.greenColor:ColorCodes.maphome),
                                              right: BorderSide(
                                                  width: 1.0, color: IConstants.isEnterprise?ColorCodes.greenColor:ColorCodes.maphome),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "+",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: ColorCodes.whiteColor
                                                //color: Theme.of(context).buttonColor,
                                              ),
                                            ),
                                          )),
                                    ),
                                  ],
                                );
                              }else{
                                widget.onempty;
                                return Row(
                                  children: <Widget>[
                                    Container(
                                        decoration: BoxDecoration(
                                          color: IConstants.isEnterprise?ColorCodes.greenColor:ColorCodes.maphome,
                                          border: Border(
                                            top: BorderSide(
                                                width: 1.0, color: IConstants.isEnterprise?ColorCodes.greenColor:ColorCodes.maphome),
                                            bottom: BorderSide(
                                                width: 1.0, color: IConstants.isEnterprise?ColorCodes.greenColor:ColorCodes.maphome),
                                            left: BorderSide(
                                                width: 1.0, color: IConstants.isEnterprise?ColorCodes.greenColor:ColorCodes.maphome),
                                          ),
                                        ),
                                        width: 30,
                                        height: 25,
                                        child: Center(
                                          child: Text(
                                            "-",
                                            textAlign: TextAlign.center,
                                            style:
                                            TextStyle(color: ColorCodes.whiteColor),
                                          ),
                                        )),
                                    Container(
                                      width: 35,
                                      height: 25,
                                      padding: EdgeInsets.only(left: 7.5, top: 2.5, right: 7.5, bottom: 2.5),
                                      child: SizedBox(
                                          width: 20.0,
                                          height: 20.0,
                                          child: new CircularProgressIndicator(
                                            strokeWidth: 2.0,
                                            valueColor: new AlwaysStoppedAnimation<Color>(IConstants.isEnterprise?ColorCodes.greenColor:ColorCodes.maphome),)),
                                    ),
                                    Container(
                                        width: 30,
                                        height: 25,
                                        decoration: BoxDecoration(
                                          color: IConstants.isEnterprise?ColorCodes.greenColor:ColorCodes.maphome,
                                          border: Border(
                                            top: BorderSide(
                                                width: 1.0, color: IConstants.isEnterprise?ColorCodes.greenColor:ColorCodes.maphome),
                                            bottom: BorderSide(
                                                width: 1.0, color: IConstants.isEnterprise?ColorCodes.greenColor:ColorCodes.maphome),
                                            right: BorderSide(
                                                width: 1.0, color: IConstants.isEnterprise?ColorCodes.greenColor:ColorCodes.maphome),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "+",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: ColorCodes.whiteColor
                                              //color: Theme.of(context).buttonColor,
                                            ),
                                          ),
                                        )),
                                  ],
                                );
                              }
                            }else if(box.isEmpty){
                              widget.onempty;
                              return Row(
                                children: <Widget>[
                                  Container(
                                      decoration: BoxDecoration(
                                        color: IConstants.isEnterprise?ColorCodes.greenColor:ColorCodes.maphome,
                                        border: Border(
                                          top: BorderSide(
                                              width: 1.0, color: IConstants.isEnterprise?ColorCodes.greenColor:ColorCodes.maphome),
                                          bottom: BorderSide(
                                              width: 1.0, color: IConstants.isEnterprise?ColorCodes.greenColor:ColorCodes.maphome),
                                          left: BorderSide(
                                              width: 1.0, color: IConstants.isEnterprise?ColorCodes.greenColor:ColorCodes.maphome),
                                        ),
                                      ),
                                      width: 30,
                                      height: 25,
                                      child: Center(
                                        child: Text(
                                          "-",
                                          textAlign: TextAlign.center,
                                          style:
                                          TextStyle(color: ColorCodes.whiteColor),
                                        ),
                                      )),
                                  Container(
                                    width: 35,
                                    height: 25,
                                    padding: EdgeInsets.only(left: 7.5, top: 2.5, right: 7.5, bottom: 2.5),
                                    child: SizedBox(
                                        width: 20.0,
                                        height: 20.0,
                                        child: new CircularProgressIndicator(
                                          strokeWidth: 2.0,
                                          valueColor: new AlwaysStoppedAnimation<Color>(IConstants.isEnterprise?ColorCodes.greenColor:ColorCodes.maphome),)),
                                  ),
                                  Container(
                                      width: 30,
                                      height: 25,
                                      decoration: BoxDecoration(
                                        color: IConstants.isEnterprise?ColorCodes.greenColor:ColorCodes.maphome,
                                        border: Border(
                                          top: BorderSide(
                                              width: 1.0, color: IConstants.isEnterprise?ColorCodes.greenColor:ColorCodes.maphome),
                                          bottom: BorderSide(
                                              width: 1.0, color: IConstants.isEnterprise?ColorCodes.greenColor:ColorCodes.maphome),
                                          right: BorderSide(
                                              width: 1.0, color: IConstants.isEnterprise?ColorCodes.greenColor:ColorCodes.maphome),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "+",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: ColorCodes.whiteColor
                                            //color: Theme.of(context).buttonColor,
                                          ),
                                        ),
                                      )),
                                ],
                              );
                            }else {
                              Future.delayed(Duration.zero).then((value) => widget.onempty);
                              return Row(
                                children: <Widget>[
                                  Container(
                                      decoration: BoxDecoration(
                                        color: IConstants.isEnterprise?ColorCodes.greenColor:ColorCodes.maphome,
                                        border: Border(
                                          top: BorderSide(
                                              width: 1.0, color: IConstants.isEnterprise?ColorCodes.greenColor:ColorCodes.maphome),
                                          bottom: BorderSide(
                                              width: 1.0, color: IConstants.isEnterprise?ColorCodes.greenColor:ColorCodes.maphome),
                                          left: BorderSide(
                                              width: 1.0, color: IConstants.isEnterprise?ColorCodes.greenColor:ColorCodes.maphome),
                                        ),
                                      ),
                                      width: 30,
                                      height: 25,
                                      child: Center(
                                        child: Text(
                                          "-",
                                          textAlign: TextAlign.center,
                                          style:
                                          TextStyle(color: ColorCodes.whiteColor),
                                        ),
                                      )),
                                  Container(
                                    width: 35,
                                    height: 25,
                                    padding: EdgeInsets.only(left: 7.5, top: 2.5, right: 7.5, bottom: 2.5),
                                    child: SizedBox(
                                        width: 20.0,
                                        height: 20.0,
                                        child: new CircularProgressIndicator(
                                          strokeWidth: 2.0,
                                          valueColor: new AlwaysStoppedAnimation<Color>(IConstants.isEnterprise?ColorCodes.greenColor:ColorCodes.maphome),)),
                                  ),
                                  Container(
                                      width: 30,
                                      height: 25,
                                      decoration: BoxDecoration(
                                        color: IConstants.isEnterprise?ColorCodes.greenColor:ColorCodes.maphome,
                                        border: Border(
                                          top: BorderSide(
                                              width: 1.0, color: IConstants.isEnterprise?ColorCodes.greenColor:ColorCodes.maphome),
                                          bottom: BorderSide(
                                              width: 1.0, color: IConstants.isEnterprise?ColorCodes.greenColor:ColorCodes.maphome),
                                          right: BorderSide(
                                              width: 1.0, color: IConstants.isEnterprise?ColorCodes.greenColor:ColorCodes.maphome),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "+",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: ColorCodes.whiteColor
                                            //color: Theme.of(context).buttonColor,
                                          ),
                                        ),
                                      )),
                                ],
                              );
                            }
                          }, mutations: {SetCartItem}),
                          SizedBox(
                            width: 10,
                          )
                        ],
                      )

                    ])),
          ],
        ),
      ),
    );
    //:SizedBox.shrink();
  }
}