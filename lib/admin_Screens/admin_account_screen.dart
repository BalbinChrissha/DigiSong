import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digisong_etr/constants/style_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:quickalert/quickalert.dart';

class AdminAccountScreen extends StatefulWidget {
  AdminAccountScreen(this.UserId, {Key? key}) : super(key: key) {
    _reference = FirebaseFirestore.instance.collection('users').doc(UserId);
    _futureData = _reference.get();
  }

  String UserId;
  late DocumentReference _reference;
  late Future<DocumentSnapshot> _futureData;

  @override
  State<AdminAccountScreen> createState() => _AdminAccountScreenState();
}

class _AdminAccountScreenState extends State<AdminAccountScreen> {
  late Map data;
  late DocumentReference _reference;
  final _formkey = GlobalKey<FormState>();
  bool isUpdate = false;

  // final fnameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final fnameController = TextEditingController();
    final lnameController = TextEditingController();

    final addressController = TextEditingController();

    return Scaffold(
        appBar: AppBar(
          backgroundColor: red,
          title: const Text(
            'Admin Account',
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  isUpdate = !isUpdate;
                });
              },
              icon: const Icon(Icons.edit),
            )
          ],
        ),
        body: FutureBuilder<DocumentSnapshot>(
            future: widget._futureData,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return Center(
                    child: Text('Some error occurred ${snapshot.error}'));
              }
              if (snapshot.hasData) {
                DocumentSnapshot documentSnapshot = snapshot.data;
                data = documentSnapshot.data() as Map;

                return SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    child: Form(
                      key: _formkey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(
                            height: 12.0,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required. Please enter your first name.';
                              }
                              return null;
                            },
                            enabled: isUpdate,
                            controller: fnameController
                              ..text = data['firstname'],
                            decoration: const InputDecoration(
                              labelText: 'First Name',
                              border: OutlineInputBorder(),
                            ),
                            style: inputTextSize,
                          ),
                          const SizedBox(
                            height: 12.0,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required. Please enter last name.';
                              }
                              return null;
                            },
                            enabled: isUpdate,
                            controller: lnameController
                              ..text = data['lastname'],
                            decoration: const InputDecoration(
                              labelText: 'Last Name',
                              border: OutlineInputBorder(),
                            ),
                            style: inputTextSize,
                          ),
                          const SizedBox(
                            height: 12.0,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required. Please enter your address.';
                              }
                              return null;
                            },
                            enabled: isUpdate,
                            controller: addressController
                              ..text = data['address'],
                            decoration: const InputDecoration(
                              labelText: 'Address',
                              border: OutlineInputBorder(),
                            ),
                            style: inputTextSize,
                            minLines: 2,
                            maxLines: 5,
                          ),
                          const SizedBox(
                            height: 12.0,
                          ),
                          Visibility(
                              visible: isUpdate,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: red),
                                      onPressed: () async {
                                        if (_formkey.currentState!.validate()) {
                                          QuickAlert.show(
                                            context: context,
                                            type: QuickAlertType.confirm,
                                            text: '',
                                            title:
                                                'Are you sure you want to update your records?',
                                            confirmBtnText: 'YES',
                                            cancelBtnText: 'No',
                                            onCancelBtnTap: () {
                                              Navigator.pop(context);
                                            },
                                            onConfirmBtnTap: () {
                                              //yes
                                              Navigator.pop(context);

                                              Map<String, dynamic>
                                                  dataToUpdate = {
                                                'firstname':
                                                    fnameController.text,
                                                'lastname':
                                                    lnameController.text,
                                                'address':
                                                    addressController.text,
                                              };

                                              //Call update()
                                              widget._reference
                                                  .update(dataToUpdate);

                                              EasyLoading.showSuccess(
                                                  'Your account has been updated.');
                                              return;
                                            },
                                          );

                                          setState(() {
                                            isUpdate = !isUpdate;
                                          });
                                        }
                                      },
                                      child: const Text(
                                        'Update',
                                        style: inputTextSize,
                                      )),
                                ],
                              ))
                        ],
                      ),
                    ),
                  ),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}
