import 'package:bornhack/ui/pages/media_archive/media_archive.view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pmvvm/pmvvm.dart';

class MediaArchivePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MVVM(
        view: () => _MediaArchivePage(),
        viewModel: MediaArchiveViewModel()
    );
  }
}

class _MediaArchivePage extends StatelessView<MediaArchiveViewModel> {
  @override
  Widget render(BuildContext context, MediaArchiveViewModel viewModel) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Media Archive'),
        ),
        body: Text('Media')
    );
  }

}