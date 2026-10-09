// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_parse.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductEntityAdapter extends TypeAdapter<ProductEntity> {
  @override
  final int typeId = 0;

  @override
  ProductEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductEntity(
      id: fields[0] as int,
      name: fields[1] as String,
      price: fields[2] as String,
      imageUrl: fields[3] as String,
      productType: fields[4] as String,
      description: fields[5] as String,
      brand: fields[6] as String,
      category: fields[7] as String,
      rating: fields[8] as double,
      reviewCount: fields[9] as int,
      shades: (fields[10] as List).cast<String>(),
      badge: fields[11] as String,
      isFeatured: fields[12] as bool,
      gallery: (fields[13] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, ProductEntity obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.imageUrl)
      ..writeByte(4)
      ..write(obj.productType)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.brand)
      ..writeByte(7)
      ..write(obj.category)
      ..writeByte(8)
      ..write(obj.rating)
      ..writeByte(9)
      ..write(obj.reviewCount)
      ..writeByte(10)
      ..write(obj.shades)
      ..writeByte(11)
      ..write(obj.badge)
      ..writeByte(12)
      ..write(obj.isFeatured)
      ..writeByte(13)
      ..write(obj.gallery);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
