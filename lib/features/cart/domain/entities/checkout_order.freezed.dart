// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checkout_order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CheckoutOrder {

 String get orderId; String get customerName; String get phoneNumber; String get pickupNote; PaymentMethod get paymentMethod; List<CartItem> get items; double get totalPrice; int get estimatedWaitMinutes; DateTime get createdAt;
/// Create a copy of CheckoutOrder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CheckoutOrderCopyWith<CheckoutOrder> get copyWith => _$CheckoutOrderCopyWithImpl<CheckoutOrder>(this as CheckoutOrder, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CheckoutOrder;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckoutOrder&&(identical(other.orderId, _this.orderId) || other.orderId == _this.orderId)&&(identical(other.customerName, _this.customerName) || other.customerName == _this.customerName)&&(identical(other.phoneNumber, _this.phoneNumber) || other.phoneNumber == _this.phoneNumber)&&(identical(other.pickupNote, _this.pickupNote) || other.pickupNote == _this.pickupNote)&&(identical(other.paymentMethod, _this.paymentMethod) || other.paymentMethod == _this.paymentMethod)&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.totalPrice, _this.totalPrice) || other.totalPrice == _this.totalPrice)&&(identical(other.estimatedWaitMinutes, _this.estimatedWaitMinutes) || other.estimatedWaitMinutes == _this.estimatedWaitMinutes)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}


@override
int get hashCode {
  final _this = this as CheckoutOrder;
  return Object.hash(runtimeType,_this.orderId,_this.customerName,_this.phoneNumber,_this.pickupNote,_this.paymentMethod,const DeepCollectionEquality().hash(_this.items),_this.totalPrice,_this.estimatedWaitMinutes,_this.createdAt);
}

@override
String toString() {
  final _this = this as CheckoutOrder;
  return 'CheckoutOrder(orderId: ${_this.orderId}, customerName: ${_this.customerName}, phoneNumber: ${_this.phoneNumber}, pickupNote: ${_this.pickupNote}, paymentMethod: ${_this.paymentMethod}, items: ${_this.items}, totalPrice: ${_this.totalPrice}, estimatedWaitMinutes: ${_this.estimatedWaitMinutes}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $CheckoutOrderCopyWith<$Res>  {
  factory $CheckoutOrderCopyWith(CheckoutOrder value, $Res Function(CheckoutOrder) _then) = _$CheckoutOrderCopyWithImpl;
@useResult
$Res call({
 String orderId, String customerName, String phoneNumber, String pickupNote, PaymentMethod paymentMethod, List<CartItem> items, double totalPrice, int estimatedWaitMinutes, DateTime createdAt
});




}
/// @nodoc
class _$CheckoutOrderCopyWithImpl<$Res>
    implements $CheckoutOrderCopyWith<$Res> {
  _$CheckoutOrderCopyWithImpl(this._self, this._then);

  final CheckoutOrder _self;
  final $Res Function(CheckoutOrder) _then;

/// Create a copy of CheckoutOrder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? orderId = null,Object? customerName = null,Object? phoneNumber = null,Object? pickupNote = null,Object? paymentMethod = null,Object? items = null,Object? totalPrice = null,Object? estimatedWaitMinutes = null,Object? createdAt = null,}) {
  return _then(CheckoutOrder(
orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,customerName: null == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,pickupNote: null == pickupNote ? _self.pickupNote : pickupNote // ignore: cast_nullable_to_non_nullable
as String,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as PaymentMethod,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<CartItem>,totalPrice: null == totalPrice ? _self.totalPrice : totalPrice // ignore: cast_nullable_to_non_nullable
as double,estimatedWaitMinutes: null == estimatedWaitMinutes ? _self.estimatedWaitMinutes : estimatedWaitMinutes // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [CheckoutOrder].
extension CheckoutOrderPatterns on CheckoutOrder {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CheckoutOrder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CheckoutOrder() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CheckoutOrder value)  $default,){
final _that = this;
switch (_that) {
case _CheckoutOrder():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CheckoutOrder value)?  $default,){
final _that = this;
switch (_that) {
case _CheckoutOrder() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String orderId,  String customerName,  String phoneNumber,  String pickupNote,  PaymentMethod paymentMethod,  List<CartItem> items,  double totalPrice,  int estimatedWaitMinutes,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CheckoutOrder() when $default != null:
return $default(_that.orderId,_that.customerName,_that.phoneNumber,_that.pickupNote,_that.paymentMethod,_that.items,_that.totalPrice,_that.estimatedWaitMinutes,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String orderId,  String customerName,  String phoneNumber,  String pickupNote,  PaymentMethod paymentMethod,  List<CartItem> items,  double totalPrice,  int estimatedWaitMinutes,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _CheckoutOrder():
return $default(_that.orderId,_that.customerName,_that.phoneNumber,_that.pickupNote,_that.paymentMethod,_that.items,_that.totalPrice,_that.estimatedWaitMinutes,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String orderId,  String customerName,  String phoneNumber,  String pickupNote,  PaymentMethod paymentMethod,  List<CartItem> items,  double totalPrice,  int estimatedWaitMinutes,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _CheckoutOrder() when $default != null:
return $default(_that.orderId,_that.customerName,_that.phoneNumber,_that.pickupNote,_that.paymentMethod,_that.items,_that.totalPrice,_that.estimatedWaitMinutes,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _CheckoutOrder implements CheckoutOrder {
  const _CheckoutOrder({required this.orderId, required this.customerName, required this.phoneNumber, required this.pickupNote, required this.paymentMethod, required  List<CartItem> items, required this.totalPrice, required this.estimatedWaitMinutes, required this.createdAt}): _items = items;
  

@override final  String orderId;
@override final  String customerName;
@override final  String phoneNumber;
@override final  String pickupNote;
@override final  PaymentMethod paymentMethod;
 final  List<CartItem> _items;
@override List<CartItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  double totalPrice;
@override final  int estimatedWaitMinutes;
@override final  DateTime createdAt;

/// Create a copy of CheckoutOrder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CheckoutOrderCopyWith<_CheckoutOrder> get copyWith => __$CheckoutOrderCopyWithImpl<_CheckoutOrder>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CheckoutOrder&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.pickupNote, pickupNote) || other.pickupNote == pickupNote)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.totalPrice, totalPrice) || other.totalPrice == totalPrice)&&(identical(other.estimatedWaitMinutes, estimatedWaitMinutes) || other.estimatedWaitMinutes == estimatedWaitMinutes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,orderId,customerName,phoneNumber,pickupNote,paymentMethod,const DeepCollectionEquality().hash(_items),totalPrice,estimatedWaitMinutes,createdAt);
}

@override
String toString() {
    return 'CheckoutOrder(orderId: $orderId, customerName: $customerName, phoneNumber: $phoneNumber, pickupNote: $pickupNote, paymentMethod: $paymentMethod, items: $items, totalPrice: $totalPrice, estimatedWaitMinutes: $estimatedWaitMinutes, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$CheckoutOrderCopyWith<$Res> implements $CheckoutOrderCopyWith<$Res> {
  factory _$CheckoutOrderCopyWith(_CheckoutOrder value, $Res Function(_CheckoutOrder) _then) = __$CheckoutOrderCopyWithImpl;
@override @useResult
$Res call({
 String orderId, String customerName, String phoneNumber, String pickupNote, PaymentMethod paymentMethod, List<CartItem> items, double totalPrice, int estimatedWaitMinutes, DateTime createdAt
});




}
/// @nodoc
class __$CheckoutOrderCopyWithImpl<$Res>
    implements _$CheckoutOrderCopyWith<$Res> {
  __$CheckoutOrderCopyWithImpl(this._self, this._then);

  final _CheckoutOrder _self;
  final $Res Function(_CheckoutOrder) _then;

/// Create a copy of CheckoutOrder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? orderId = null,Object? customerName = null,Object? phoneNumber = null,Object? pickupNote = null,Object? paymentMethod = null,Object? items = null,Object? totalPrice = null,Object? estimatedWaitMinutes = null,Object? createdAt = null,}) {
  return _then(_CheckoutOrder(
orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,customerName: null == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,pickupNote: null == pickupNote ? _self.pickupNote : pickupNote // ignore: cast_nullable_to_non_nullable
as String,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as PaymentMethod,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<CartItem>,totalPrice: null == totalPrice ? _self.totalPrice : totalPrice // ignore: cast_nullable_to_non_nullable
as double,estimatedWaitMinutes: null == estimatedWaitMinutes ? _self.estimatedWaitMinutes : estimatedWaitMinutes // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
