import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../models/collections.dart';
import '../models/collections_photos.dart';
import '../models/details_photo.dart';
import '../services/http_service.dart';
import '../services/log_service.dart';
import 'details_page.dart';

class CollectionPhotosPage extends StatefulWidget {
  final Collections? collection;

  const CollectionPhotosPage({super.key, this.collection});

  @override
  State<CollectionPhotosPage> createState() => _CollectionPhotosPageState();
}

class _CollectionPhotosPageState extends State<CollectionPhotosPage> {
  DetailsPhoto? detailsPhoto;
  bool isLoading = true;
  late Collections collection;
  List<CollectionsPhotos> collectionPhotos = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    collection = widget.collection!;
    _apiCollectionPhotos();
  }

  _apiCollectionPhotos() async {
    var response = await Network.GET(
        Network.API_COLLECTIONS_PHOTOS.replaceFirst(':id', collection.id),
        Network.paramsCollectionsPhotos());
    LogService.d(response!);
    setState(() {
      collectionPhotos = Network.parseCollectionsPhotos(response);
      isLoading = false;
    });
  }

  _callDetailsPage(DetailsPhoto photo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return DetailsPage(detailsPhoto: photo);
        },
      ),
    );
  }

  DetailsPhoto getPhoto(CollectionsPhotos photo) {
    return DetailsPhoto(
      id: photo.id,
      createdAt: photo.createdAt,
      width: photo.width,
      height: photo.height,
      description: photo.description,
      urls: photo.urls,
      user: photo.user,
    );
  }

  Future<void> _handleRefresh() async {
    _apiCollectionPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.collection!.title),
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _handleRefresh,
            child: Container(
              padding: const EdgeInsets.only(right: 5),
              child: MasonryGridView.count(
                itemCount: collectionPhotos.length,
                crossAxisCount: 2,
                itemBuilder: (context, index) {
                  return _itemOfCollectionPhotos(collectionPhotos[index]);
                },
              ),
            ),
          ),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : collectionPhotos.isEmpty ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    // color: Colors.blue,
                    borderRadius: BorderRadius.circular(50),
                    image: const DecorationImage(
                      colorFilter: ColorFilter.srgbToLinearGamma(),
                      image: AssetImage('assets/images/no_data.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                const Text('Nothing to see here...')
              ],
            ),
          ) : SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _itemOfCollectionPhotos(CollectionsPhotos photos) {
    return Hero(
      tag: photos.id,
      child: AspectRatio(
        aspectRatio: photos.width.toDouble() / photos.height.toDouble(),
        child: GestureDetector(
          onTap: () {
            _callDetailsPage(getPhoto(photos));
            LogService.i(photos.description.toString());
          },
          child: Container(
            margin: const EdgeInsets.only(top: 5, left: 5),
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: photos.urls.full,
              placeholder: (context, urls) => Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              errorWidget: (context, urls, error) => Icon(Icons.error),
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
