// // GENERATED CODE - DO NOT MODIFY BY HAND

// part of 'report_model.dart';

// // **************************************************************************
// // TypeAdapterGenerator
// // **************************************************************************

// class ReportModelAdapter extends TypeAdapter<ReportModel> {
//   @override
//   final int typeId = 0;

//   @override
//   ReportModel read(BinaryReader reader) {
//     final numOfFields = reader.readByte();
//     final fields = <int, dynamic>{
//       for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
//     };
//     return ReportModel(
//       reportId: fields[0] as int,
//       title: fields[1] as String,
//       description: fields[2] as String?,
//       latitude: fields[3] as double?,
//       longitude: fields[4] as double?,
//       contactInfo: fields[5] as String?,
//       department: fields[6] as String,
//       createdAt: fields[7] as DateTime,
//       currentStatus: fields[8] as String,
//       cityName: fields[9] as String?,
//     );
//   }

//   @override
//   void write(BinaryWriter writer, ReportModel obj) {
//     writer
//       ..writeByte(10)
//       ..writeByte(0)
//       ..write(obj.reportId)
//       ..writeByte(1)
//       ..write(obj.title)
//       ..writeByte(2)
//       ..write(obj.description)
//       ..writeByte(3)
//       ..write(obj.latitude)
//       ..writeByte(4)
//       ..write(obj.longitude)
//       ..writeByte(5)
//       ..write(obj.contactInfo)
//       ..writeByte(6)
//       ..write(obj.department)
//       ..writeByte(7)
//       ..write(obj.createdAt)
//       ..writeByte(8)
//       ..write(obj.currentStatus)
//       ..writeByte(9)
//       ..write(obj.cityName);
//   }

//   @override
//   int get hashCode => typeId.hashCode;

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is ReportModelAdapter &&
//           runtimeType == other.runtimeType &&
//           typeId == other.typeId;
// }
