// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Order {

/// Unique order identifier (e.g. 'ORD-104').
 String get id;/// Customer display name captured at checkout.
 String get customerName;/// Snapshot of cart items at the time of ordering.
 List<CartItem> get items;/// Pre-calculated total in ETB.
 double get totalPrice;/// Estimated minutes until pickup, computed from item prep times.
 int get estimatedWaitMinutes;/// Timestamp when the order was placed.
 DateTime get createdAt;/// Current lifecycle status, starts at [OrderStatus.placed].
 OrderStatus get status;
/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderCopyWith<Order> get copyWith => _$OrderCopyWithImpl<Order>(this as Order, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Order;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Order&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.customerName, _this.customerName) || other.customerName == _this.customerName)&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.totalPrice, _this.totalPrice) || other.totalPrice == _this.totalPrice)&&(identical(other.estimatedWaitMinutes, _this.estimatedWaitMinutes) || other.estimatedWaitMinutes == _this.estimatedWaitMinutes)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.status, _this.status) || other.status == _this.status));
}


@override
int get hashCode {
  final _this = this as Order;
  return Object.hash(runtimeType,_this.id,_this.customerName,const DeepCollectionEquality().hash(_this.items),_this.totalPrice,_this.estimatedWaitMinutes,_this.createdAt,_this.status);
}

@override
String toString() {
  final _this = this as Order;
  return 'Order(id: ${_this.id}, customerName: ${_this.customerName}, items: ${_this.items}, totalPrice: ${_this.totalPrice}, estimatedWaitMinutes: ${_this.estimatedWaitMinutes}, createdAt: ${_this.createdAt}, status: ${_this.status})';
}


}

/// @nodoc
abstract mixin class $OrderCopyWith<$Res>  {
  factory $OrderCopyWith(Order value, $Res Function(Order) _then) = _$OrderCopyWithImpl;
@useResult
$Res call({
 String id, String customerName, List<CartItem> items, double totalPrice, int estimatedWaitMinutes, DateTime createdAt, OrderStatus status
});




}
/// @nodoc
class _$OrderCopyWithImpl<$Res>
    implements $OrderCopyWith<$Res> {
  _$OrderCopyWithImpl(this._self, this._then);

  final Order _self;
  final $Res Function(Order) _then;

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? customerName = null,Object? items = null,Object? totalPrice = null,Object? estimatedWaitMinutes = null,Object? createdAt = null,Object? status = null,}) {
  return _then(Order(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,customerName: null == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<CartItem>,totalPrice: null == totalPrice ? _self.totalPrice : totalPrice // ignore: cast_nullable_to_non_nullable
as double,estimatedWaitMinutes: null == estimatedWaitMinutes ? _self.estimatedWaitMinutes : estimatedWaitMinutes // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [Order].
extension OrderPatterns on Order {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Order value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Order() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Order value)  $default,){
final _that = this;
switch (_that) {
case _Order():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Order value)?  $default,){
final _that = this;
switch (_that) {
case _Order() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String customerName,  List<CartItem> items,  double totalPrice,  int estimatedWaitMinutes,  DateTime createdAt,  OrderStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Order() when $default != null:
return $default(_that.id,_that.customerName,_that.items,_that.totalPrice,_that.estimatedWaitMinutes,_that.createdAt,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String customerName,  List<CartItem> items,  double totalPrice,  int estimatedWaitMinutes,  DateTime createdAt,  OrderStatus status)  $default,) {final _that = this;
switch (_that) {
case _Order():
return $default(_that.id,_that.customerName,_that.items,_that.totalPrice,_that.estimatedWaitMinutes,_that.createdAt,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String customerName,  List<CartItem> items,  double totalPrice,  int estimatedWaitMinutes,  DateTime createdAt,  OrderStatus status)?  $default,) {final _that = this;
switch (_that) {
case _Order() when $default != null:
return $default(_that.id,_that.customerName,_that.items,_that.totalPrice,_that.estimatedWaitMinutes,_that.createdAt,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _Order implements Order {
  const _Order({required this.id, required this.customerName, required  List<CartItem> items, required this.totalPrice, required this.estimatedWaitMinutes, required this.createdAt, this.status = OrderStatus.placed}): _items = items;
  

/// Unique order identifier (e.g. 'ORD-104').
@override final  String id;
/// Customer display name captured at checkout.
@override final  String customerName;
/// Snapshot of cart items at the time of ordering.
 final  List<CartItem> _items;
/// Snapshot of cart items at the time of ordering.
@override List<CartItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

/// Pre-calculated total in ETB.
@override final  double totalPrice;
/// Estimated minutes until pickup, computed from item prep times.
@override final  int estimatedWaitMinutes;
/// Timestamp when the order was placed.
@override final  DateTime createdAt;
/// Current lifecycle status, starts at [OrderStatus.placed].
@override@JsonKey() final  OrderStatus status;

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderCopyWith<_Order> get copyWith => __$OrderCopyWithImpl<_Order>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Order&&(identical(other.id, id) || other.id == id)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.totalPrice, totalPrice) || other.totalPrice == totalPrice)&&(identical(other.estimatedWaitMinutes, estimatedWaitMinutes) || other.estimatedWaitMinutes == estimatedWaitMinutes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,customerName,const DeepCollectionEquality().hash(_items),totalPrice,estimatedWaitMinutes,createdAt,status);
}

@override
String toString() {
    return 'Order(id: $id, customerName: $customerName, items: $items, totalPrice: $totalPrice, estimatedWaitMinutes: $estimatedWaitMinutes, createdAt: $createdAt, status: $status)';
}


}

/// @nodoc
abstract mixin class _$OrderCopyWith<$Res> implements $OrderCopyWith<$Res> {
  factory _$OrderCopyWith(_Order value, $Res Function(_Order) _then) = __$OrderCopyWithImpl;
@override @useResult
$Res call({
 String id, String customerName, List<CartItem> items, double totalPrice, int estimatedWaitMinutes, DateTime createdAt, OrderStatus status
});




}
/// @nodoc
class __$OrderCopyWithImpl<$Res>
    implements _$OrderCopyWith<$Res> {
  __$OrderCopyWithImpl(this._self, this._then);

  final _Order _self;
  final $Res Function(_Order) _then;

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? customerName = null,Object? items = null,Object? totalPrice = null,Object? estimatedWaitMinutes = null,Object? createdAt = null,Object? status = null,}) {
  return _then(_Order(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,customerName: null == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<CartItem>,totalPrice: null == totalPrice ? _self.totalPrice : totalPrice // ignore: cast_nullable_to_non_nullable
as double,estimatedWaitMinutes: null == estimatedWaitMinutes ? _self.estimatedWaitMinutes : estimatedWaitMinutes // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderStatus,
  ));
}


}

// dart format on
