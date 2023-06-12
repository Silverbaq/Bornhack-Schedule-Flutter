import 'package:bornhack/ui/pages/media_archive/media_archive.view_model.dart';
import 'package:bornhack/ui/pages/media_archive/upload/upload_media.page.dart';
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
        body: Column(
          children: [
            TextButton.icon(
              icon: const Icon(
                Icons.add,
                color: Colors.blueAccent,
              ),
              label: Text(
                'Add item',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: Colors.blueAccent),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UploadMediaPage()));
                //NavigationHelper.navigateToNewItemPage(context);
              },
            ),





            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
                childAspectRatio: 0.85,
              ),
              itemCount: viewModel.files.length,
              itemBuilder: (context, index) {
                var file = viewModel.files[index];
                var url = viewModel.mediaUrl+file.thumbnail_url;

                return Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Image.network(
                    url,
                    fit: BoxFit.cover,
                    headers: {'Cookie': 'bma_sessionid=0kr19jifvdvp0j6lsux34bvplv301x4j'},
                  ),
                );

              },
            ),
          ],
        )
    );
  }

}