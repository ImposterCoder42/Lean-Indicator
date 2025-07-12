// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ride_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RideDataPointAdapter extends TypeAdapter<RideDataPoint> {
  @override
  final int typeId = 0;

  @override
  RideDataPoint read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RideDataPoint(
      angle: fields[0] as double,
      speed: fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, RideDataPoint obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.angle)
      ..writeByte(1)
      ..write(obj.speed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RideDataPointAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SingleRideAdapter extends TypeAdapter<SingleRide> {
  @override
  final int typeId = 1;

  @override
  SingleRide read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SingleRide(
      title: fields[2] as String,
      rideData: (fields[3] as List).cast<RideDataPoint>(),
    );
  }

  @override
  void write(BinaryWriter writer, SingleRide obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.rideData);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SingleRideAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
