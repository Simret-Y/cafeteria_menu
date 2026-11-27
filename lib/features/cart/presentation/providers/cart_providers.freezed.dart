// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CartState {

 List<CartItem> get items; PaymentMethod get selectedPaymentMethod; CheckoutOrder? get lastPlacedOrder; List<CheckoutOrder> get placedOrders;
/// Create a copy of CartState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CartStateCopyWith<CartState> get copyWith => _$CartStateCopyWithImpl<CartState>(this as CartState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CartState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CartState&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.selectedPaymentMethod, _this.selectedPaymentMethod) || other.selectedPaymentMethod == _this.selectedPaymentMethod)&&(identical(other.lastPlacedOrder, _this.lastPlacedOrder) || other.lastPlacedOrder == _this.lastPlacedOrder)&&const DeepCollectionEquality().equals(other.placedOrders, _this.placedOrders));
}


@override
int get hashCode {
  final _this = this as CartState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.items),_this.selectedPaymentMethod,_this.lastPlacedOrder,const DeepCollectionEquality().hash(_this.placedOrders));
}

@override
String toString() {
  final _this = this as CartState;
  return 'CartState(items: ${_this.items}, selectedPaymentMethod: ${_this.selectedPaymentMethod}, lastPlacedOrder: ${_this.lastPlacedOrder}, placedOrders: ${_this.placedOrders})';
}


}

/// @nodoc
abstract mixin class $CartStateCopyWith<$Res>  {
  factory $CartStateCopyWith(CartState value, $Res Function(CartState) _then) = _$CartStateCopyWithImpl;
@useResult
$Res call({
 List<CartItem> items, PaymentMethod selectedPaymentMethod, CheckoutOrder? lastPlacedOrder, List<CheckoutOrder> placedOrders
});


$CheckoutOrderCopyWith<$Res>? get lastPlacedOrder;

}
/// @nodoc
class _$CartStateCopyWithImpl<$Res>
    implements $CartStateCopyWith<$Res> {
  _$CartStateCopyWithImpl(this._self, this._then);

  final CartState _self;
  final $Res Function(CartState) _then;

/// Create a copy of CartState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? selectedPaymentMethod = null,Object? lastPlacedOrder = freezed,Object? placedOrders = null,}) {
  return _then(CartState(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<CartItem>,selectedPaymentMethod: null == selectedPaymentMethod ? _self.selectedPaymentMethod : selectedPaymentMethod // ignore: cast_nullable_to_non_nullable
as PaymentMethod,lastPlacedOrder: freezed == lastPlacedOrder ? _self.lastPlacedOrder : lastPlacedOrder // ignore: cast_nullable_to_non_nullable
as CheckoutOrder?,placedOrders: null == placedOrders ? _self.placedOrders : placedOrders // ignore: cast_nullable_to_non_nullable
as List<CheckoutOrder>,
  ));
}
/// Create a copy of CartState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CheckoutOrderCopyWith<$Res>? get lastPlacedOrder {
    if (_self.lastPlacedOrder == null) {
    return null;
  }

  return $CheckoutOrderCopyWith<$Res>(_self.lastPlacedOrder!, (value) {
    return _then(_self.copyWith(lastPlacedOrder: value));
  });
}
}


/// Adds pattern-matching-related methods to [CartState].
extension CartStatePatterns on CartState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CartState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CartState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CartState value)  $default,){
final _that = this;
switch (_that) {
case _CartState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CartState value)?  $default,){
final _that = this;
switch (_that) {
case _CartState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<CartItem> items,  PaymentMethod selectedPaymentMethod,  CheckoutOrder? lastPlacedOrder,  List<CheckoutOrder> placedOrders)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CartState() when $default != null:
return $default(_that.items,_that.selectedPaymentMethod,_that.lastPlacedOrder,_that.placedOrders);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<CartItem> items,  PaymentMethod selectedPaymentMethod,  CheckoutOrder? lastPlacedOrder,  List<CheckoutOrder> placedOrders)  $default,) {final _that = this;
switch (_that) {
case _CartState():
return $default(_that.items,_that.selectedPaymentMethod,_that.lastPlacedOrder,_that.placedOrders);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<CartItem> items,  PaymentMethod selectedPaymentMethod,  CheckoutOrder? lastPlacedOrder,  List<CheckoutOrder> placedOrders)?  $default,) {final _that = this;
switch (_that) {
case _CartState() when $default != null:
return $default(_that.items,_that.selectedPaymentMethod,_that.lastPlacedOrder,_that.placedOrders);case _:
  return null;

}
}

}

/// @nodoc


class _CartState extends CartState {
  const _CartState({ List<CartItem> items = const [], this.selectedPaymentMethod = PaymentMethod.counter, this.lastPlacedOrder,  List<CheckoutOrder> placedOrders = const []}): _items = items,_placedOrders = placedOrders,super._();
  

 final  List<CartItem> _items;
@override@JsonKey() List<CartItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey() final  PaymentMethod selectedPaymentMethod;
@override final  CheckoutOrder? lastPlacedOrder;
 final  List<CheckoutOrder> _placedOrders;
@override@JsonKey() List<CheckoutOrder> get placedOrders {
  if (_placedOrders is EqualUnmodifiableListView) return _placedOrders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_placedOrders);
}


/// Create a copy of CartState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CartStateCopyWith<_CartState> get copyWith => __$CartStateCopyWithImpl<_CartState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CartState&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.selectedPaymentMethod, selectedPaymentMethod) || other.selectedPaymentMethod == selectedPaymentMethod)&&(identical(other.lastPlacedOrder, lastPlacedOrder) || other.lastPlacedOrder == lastPlacedOrder)&&const DeepCollectionEquality().equals(other.placedOrders, _placedOrders));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),selectedPaymentMethod,lastPlacedOrder,const DeepCollectionEquality().hash(_placedOrders));
}

@override
String toString() {
    return 'CartState(items: $items, selectedPaymentMethod: $selectedPaymentMethod, lastPlacedOrder: $lastPlacedOrder, placedOrders: $placedOrders)';
}


}

/// @nodoc
abstract mixin class _$CartStateCopyWith<$Res> implements $CartStateCopyWith<$Res> {
  factory _$CartStateCopyWith(_CartState value, $Res Function(_CartState) _then) = __$CartStateCopyWithImpl;
@override @useResult
$Res call({
 List<CartItem> items, PaymentMethod selectedPaymentMethod, CheckoutOrder? lastPlacedOrder, List<CheckoutOrder> placedOrders
});


@override $CheckoutOrderCopyWith<$Res>? get lastPlacedOrder;

}
/// @nodoc
class __$CartStateCopyWithImpl<$Res>
    implements _$CartStateCopyWith<$Res> {
  __$CartStateCopyWithImpl(this._self, this._then);

  final _CartState _self;
  final $Res Function(_CartState) _then;

/// Create a copy of CartState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? selectedPaymentMethod = null,Object? lastPlacedOrder = freezed,Object? placedOrders = null,}) {
  return _then(_CartState(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<CartItem>,selectedPaymentMethod: null == selectedPaymentMethod ? _self.selectedPaymentMethod : selectedPaymentMethod // ignore: cast_nullable_to_non_nullable
as PaymentMethod,lastPlacedOrder: freezed == lastPlacedOrder ? _self.lastPlacedOrder : lastPlacedOrder // ignore: cast_nullable_to_non_nullable
as CheckoutOrder?,placedOrders: null == placedOrders ? _self._placedOrders : placedOrders // ignore: cast_nullable_to_non_nullable
as List<CheckoutOrder>,
  ));
}

/// Create a copy of CartState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CheckoutOrderCopyWith<$Res>? get lastPlacedOrder {
    if (_self.lastPlacedOrder == null) {
    return null;
  }

  return $CheckoutOrderCopyWith<$Res>(_self.lastPlacedOrder!, (value) {
    return _then(_self.copyWith(lastPlacedOrder: value));
  });
}
}

// dart format on
