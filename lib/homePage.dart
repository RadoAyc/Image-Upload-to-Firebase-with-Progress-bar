import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File _image;
bool _isloadig = false;
double _progress;
   getImage(source) async {
    var image = await ImagePicker.pickImage(source: source, );
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: image.path);

    setState(() {
      _image = croppedFile;
    });
  }

    progress(loading){
      if (loading) {
        return Column(
        children: <Widget>[
          LinearProgressIndicator(
            value: _progress,
            backgroundColor: Colors.grey,
          ),
          Text('${(_progress * 100).toStringAsFixed(2)} %')
        ],
      );
      } else {
       return Text('Nothing');
      }
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Image Upload'),),
      body: Column(
        children: <Widget>[
          Center(
            child: _image == null
                ? Text('No image selected.')
                : Image.file(
                  _image,
                  height: 512,
                  width: 512,
                  ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton.icon(
                  onPressed:() => getImage(ImageSource.camera), 
                  icon: Icon(Icons.camera), 
                  label: Text('Camera')),
                  FlatButton.icon(
                  onPressed: ()=> getImage(ImageSource.gallery), 
                  icon: Icon(Icons.photo_library), 
                  label: Text('Camera')),
                  FlatButton.icon(
                  onPressed: ()  async{
                    final StorageReference storageReference = FirebaseStorage().ref().child('path.jpg');
                    final StorageUploadTask uploadTask = storageReference.putFile(_image);
                    
                    uploadTask.events.listen((event){
                      setState(() {
                        _isloadig = true;
                        _progress = event.snapshot.bytesTransferred.toDouble() / event.snapshot.totalByteCount.toDouble();
                        print(_progress);
                      });
                    });

                  }, 
                  icon: Icon(Icons.cloud_upload), 
                  label: Text('Upload')),

              ],
            ),

          ),
          progress(_isloadig)
 
        ],
      ),
    );
  }
}