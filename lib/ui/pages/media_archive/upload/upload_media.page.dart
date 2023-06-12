import 'dart:io';

import 'package:bornhack/app.dart';
import 'package:bornhack/ui/pages/media_archive/upload/upload_media.page.viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:pmvvm/pmvvm.dart';

class UploadMediaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => _UploadMediaPage(),
      viewModel: UploadMediaViewModel(getIt.get()),
    );
  }
}

class _UploadMediaPage extends StatelessView<UploadMediaViewModel> {
  @override
  Widget render(BuildContext context, UploadMediaViewModel viewModel) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Upload Media'),
        ),
        body: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              GestureDetector(
                child: viewModel.image != null
                    ? Image.file(viewModel.image ?? File(""))
                    : Text('Select an image', style: Theme.of(context)
                    .textTheme
                    .titleLarge),
                onTap: () async {
                  await viewModel.selectedImageFromGallery();
                },
              ),
              SizedBox(
                height: 8,
              ),
              TextField(
                controller: TextEditingController(),
                onChanged: (value) => viewModel.updateTitle(value),
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Title',
                    hintText: 'Enter Title'),
              ),
              SizedBox(
                height: 8,
              ),
              TextField(
                controller: TextEditingController(),
                onChanged: (value) => viewModel.updateDescription(value),
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Description',
                    hintText: 'Enter a description'),
              ),
              SizedBox(
                height: 8,
              ),
              TextField(
                controller: TextEditingController(),
                onChanged: (value) => viewModel.updateSource(value),
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Source',
                    hintText: 'Enter source'),
              ),
              SizedBox(
                height: 8,
              ),
              ElevatedButton(
                  onPressed: () async {
                    await viewModel.uploadFile();
                  },
                  child: Text('Upload')),
            ],
          ),
        ));
  }
}
