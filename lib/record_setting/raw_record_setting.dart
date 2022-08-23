import 'package:flutter/material.dart';

import 'package:ndef/ndef.dart' as ndef;

class NDEFRecordSetting extends StatefulWidget {
  final ndef.NDEFRecord record;
  NDEFRecordSetting({Key? key, ndef.NDEFRecord? record})
      : record = record ?? ndef.NDEFRecord(),
        super(key: key);
  @override
  _NDEFRecordSetting createState() => _NDEFRecordSetting();
}

class _NDEFRecordSetting extends State<NDEFRecordSetting> {
  GlobalKey formKey = GlobalKey<FormState>();
  late TextEditingController _identifierController;
  late TextEditingController _payloadController;
  late TextEditingController _typeController;
  late int _dropButtonValue;

  @override
  initState() {
    super.initState();

    if (widget.record.id == null) {
      _identifierController =
          TextEditingController.fromValue(const TextEditingValue(text: ""));
    } else {
      _identifierController = TextEditingController.fromValue(
          TextEditingValue(text: widget.record.id!.toHexString()));
    }
    if (widget.record.payload == null) {
      _payloadController =
          TextEditingController.fromValue(const TextEditingValue(text: ""));
    } else {
      _payloadController = TextEditingController.fromValue(
          TextEditingValue(text: widget.record.payload!.toHexString()));
    }
    if (widget.record.encodedType == null &&
        widget.record.decodedType == null) {
      // bug in ndef package (fixed in newest version)
      _typeController =
          TextEditingController.fromValue(const TextEditingValue(text: ""));
    } else {
      _typeController = TextEditingController.fromValue(
          TextEditingValue(text: widget.record.type!.toHexString()));
    }
    _dropButtonValue = ndef.TypeNameFormat.values.indexOf(widget.record.tnf);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Set Record'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.always,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  DropdownButton(
                    value: _dropButtonValue,
                    items: const [
                      DropdownMenuItem(
                        child: Text('empty'),
                        value: 0,
                      ),
                      DropdownMenuItem(
                        child: Text('nfcWellKnown'),
                        value: 1,
                      ),
                      DropdownMenuItem(
                        child: Text('media'),
                        value: 2,
                      ),
                      DropdownMenuItem(
                        child: Text('absoluteURI'),
                        value: 3,
                      ),
                      DropdownMenuItem(child: Text('nfcExternal'), value: 4),
                      DropdownMenuItem(child: Text('unchanged'), value: 5),
                      DropdownMenuItem(
                        child: Text('unknown'),
                        value: 6,
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _dropButtonValue = value as int;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'identifier'),
                    validator: (v) {
                      return v!.trim().length % 2 == 0
                          ? null
                          : 'length must be even';
                    },
                    controller: _identifierController,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'type'),
                    validator: (v) {
                      return v!.trim().length % 2 == 0
                          ? null
                          : 'length must be even';
                    },
                    controller: _typeController,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'payload'),
                    validator: (v) {
                      return v!.trim().length % 2 == 0
                          ? null
                          : 'length must be even';
                    },
                    controller: _payloadController,
                  ),
                  ElevatedButton(
                    child: const Text('OK'),
                    onPressed: () {
                      if ((formKey.currentState as FormState).validate()) {
                        Navigator.pop(
                            context,
                            ndef.NDEFRecord(
                                tnf: ndef
                                    .TypeNameFormat.values[_dropButtonValue],
                                type: (_typeController.text).toBytes(),
                                id: (_identifierController.text).toBytes(),
                                payload: (_payloadController.text).toBytes()));
                      }
                    },
                  ),
                  ElevatedButton(
                    child: const Text('Delete'),
                    onPressed: () {
                      if ((formKey.currentState as FormState).validate()) {
                        Navigator.pop(context, 'Delete');
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
