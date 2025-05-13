import 'package:flutter/material.dart';
import 'package:frontend1/templates/CustomizedPage/home_page1.dart';
import 'package:frontend1/templates/CustomizedPage/models/pageModel.dart';
import 'package:provider/provider.dart';

class PageScreen extends StatefulWidget {
   final String token;
    final String templateId;


  const PageScreen({super.key, required this.token,required this.templateId});

  @override
  _PageScreenState createState() => _PageScreenState();
}

class _PageScreenState extends State<PageScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async{
    // Fetch the page data after the widget has been built
    final pageProvider =Provider.of<PageProvider>(context, listen: false);
    pageProvider.fetchPage(widget.templateId);
  });
  }

  @override
  Widget build(BuildContext context) {
    final pageProvider = Provider.of<PageProvider>(context);

    return Scaffold(
    //  appBar: AppBar(title: Text("Page Details")),
      body: pageProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : pageProvider.error != null
              ?
               Center(child: Text("page provider ${pageProvider.error!}"))
             
              : pageProvider.page != null
                  ? CustomPage2(page: pageProvider.page!)
                  : Center(child: Text("No page data")),
    );
  }
}