import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend1/templates/CustomizedPage/Providers/services.dart';
import 'package:frontend1/templates/CustomizedPage/models/elementsModels.dart';
import 'package:frontend1/templates/CustomizedPage/models/pageModel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ImageAttachmentWidget extends StatefulWidget {
  final int index;

  const ImageAttachmentWidget({super.key, required this.index});

  @override
  _ImageAttachmentWidgetState createState() => _ImageAttachmentWidgetState();
}

class _ImageAttachmentWidgetState extends State<ImageAttachmentWidget> {
  File? image;

  @override
  late PageModel page; // Declare page outside the function as a class variable

  @override
  void initState() {
    super.initState();
    print("inside image init state");
    print(widget.index);
    _initializePage(); // Initialize the page when the widget is first created
  }

  // Initialize the page and fetch the image
  Future<void> _initializePage() async {
    final fetchedPage = context.read<PageProvider>().page;
    if (fetchedPage != null) {
      setState(() {
        page = fetchedPage; // Store the page outside the function
      });

      _fetchImage(); // Now fetch the image after the page has been initialized
    }
  }
  // Fetch the image URL from the provider or service
  Future<void> _fetchImage() async {
    final page = context.read<PageProvider>().page;
    if (page != null && page.elements.isNotEmpty && widget.index >= 0 && widget.index < page.elements.length) {
    final imageElement = page.elements[widget.index];

    if (imageElement is ImageElementModel) {
      setState(() {
     
         if (imageElement.url != null) {
    image = File(imageElement.url!); // Using '!' to safely unwrap the URL
    print("image is $image");
  } else {
    image = null; // Set image to null if URL is null
    print("No image available, URL is null");
  }
      });
    }
  }
}

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path); // Store the selected image file
      });

      // After picking an image, update the provider with the new image URL
      await _updateImageUrl();  // Update the image URL to the provider and API

    }
  }

  // Update image URL in the provider and API
  Future<void> _updateImageUrl() async {
    print(image);
    if (image == null) return;
/*
    final imageElement = ImageElementModel(
      position: Offset(0.0, 0.0),  // Set the position accordingly
      size: Size(150.0, 150.0),     // Set the size accordingly
    //  id: widget.id,
      url: image!.path,         // Assuming the image path is the URL
    );
    */
     dynamic newContent = {
    'url':image!.path, // New content with a URL
  };
updateElementContent(pageId:page.id,elementIndex:widget.index,newContent:newContent);
    // Update the image element in the provider
   // await context.read<PageProvider>().updateImageElement(widget.index,imageElement);
  }

  @override
  Widget build(BuildContext context) {
      print("width is ${ page.elements[widget.index].size.width} ,, height is ${ page.elements[widget.index].size.height}");
    return 
    /*
    Container(
      width: page.elements[widget.index].size.width,
         height: page.elements[widget.index].size.height,
       // width:100,
       // height:100,
   child:
   */
    GestureDetector(
      onTap: _pickImage, // Trigger image picker on tap
      child: Container(
        width: page.elements[widget.index].size.width,
        height: page.elements[widget.index].size.height,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: image == null 
            ? Center(
                child: Icon(
                  Icons.add_a_photo,
                  size: 50,
                  color: Colors.grey,
                ),
              )
            : Image.file(
                image!,
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
              
              /*
              :
              Image.asset(

'lib/images/p.jpg',                 width: 150,
                height: 150,
                fit: BoxFit.fill,
              ),
              */
   //   ),
   
    ),
    );
  }
}

