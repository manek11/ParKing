import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ParkingRequest {
  String prid;
  String uid;
  String pid;
  String ppid;
  DateTime timeOfBooking;
  DateTime timeOfCreation;
  double duration;
  String qrInput;
  String qrEntryValue;
  String progress;
  bool inParking;
  String location;

  ParkingRequest({
    @required this.prid,
    @required this.uid,
    @required this.pid,
    @required this.ppid,
    @required this.timeOfBooking,
    this.inParking,
    this.duration,
    this.progress,
    this.qrInput,
    this.location,
  });

  factory ParkingRequest.fromDocument(DocumentSnapshot doc) {
    return ParkingRequest(
      prid: doc.get('prid'),
      uid: doc.get('uid'),
      pid: doc.get('pid'),
      ppid: doc.get('ppid'),
      timeOfBooking: DateTime.tryParse(doc.get('timeOfBooking')),
      duration: doc.get('duration'),
      qrInput: doc.get('qrInput'),
      progress: doc.get('progress'),
      inParking: doc.get('inParking'),
      location: doc.get('location'),
    );
  }

  Map<String, dynamic> toMap(ParkingRequest parkingRequest) {
    return {
      'prid': parkingRequest.prid,
      'uid': parkingRequest.uid,
      'pid': parkingRequest.pid,
      'ppid': parkingRequest.ppid,
      'timeOfBooking': parkingRequest.timeOfBooking.toIso8601String(),
      'duration': parkingRequest.duration,
      'qrInput': parkingRequest.qrInput,
      'progress': parkingRequest.progress,
      'inParking': parkingRequest.inParking,
      'location': parkingRequest.location,
    };
  }

  ParkingRequest.fromMap(Map<String, dynamic> mapData) {
    prid = mapData['prid'];
    uid = mapData['uid'];
    pid = mapData['pid'];
    ppid = mapData['ppid'];
    timeOfBooking = mapData['timeOfBooking'].toIso8601String();
    duration = mapData['duration'];
    qrInput = mapData['qrInput'];
    progress = mapData['progress'];
    inParking = mapData['inParking'];
    location = mapData['location'];
  }
}