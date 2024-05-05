

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:iconsax/iconsax.dart';
import '../models/details_photo.dart';
import '../models/photos.dart';
import '../models/search_photos.dart';
import '../services/http_service.dart';
import '../services/log_service.dart';
import 'details_page.dart';

class SearchPage extends StatefulWidget {
  static const String id = 'search_page';
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool isLoading = true;
  DetailsPhoto? detailsPhoto;
  String? query;
  List<Photo> photos = [];
  List<SearchPhoto> searchPhotos = [];
  ScrollController photosScrollController = ScrollController();
  ScrollController searchPhotosScrollController = ScrollController();
  int currentPhotosPage = 1;
  int currentSearchPhotosPage = 1;



  final TextEditingController _queryController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    apiPhotos();
    photosScrollController.addListener(() {
      if (photosScrollController.position.maxScrollExtent <=
          photosScrollController.offset) {
        currentPhotosPage++;
        apiPhotos();
      }
    });

    if (query != null) {
      apiSearchPhotos(query);
    }

    searchPhotosScrollController.addListener(() {
      if (searchPhotosScrollController.position.maxScrollExtent <=
          searchPhotosScrollController.offset) {
        currentSearchPhotosPage++;
        apiSearchPhotos(query);
      }
    });
  }



  apiPhotos() async {
    try {

      var response =
      await Network.GET(Network.API_PHOTOS, Network.paramsPhotos(currentPhotosPage));
      setState(() {
        photos.addAll (Network.parsePhotosList(response!));
        isLoading = false;
      });
      LogService.d(photos.length.toString());
    } catch (e){
      LogService.e(e.toString());
    }
  }

apiSearchPhotos(String? query) async {
  try {
    var response = await Network.GET(Network.API_SEARCH_PHOTOS,
        Network.paramsSearchPhotos(query!, currentSearchPhotosPage));
    setState(() {
      searchPhotos.addAll((Network.parseSearchPhotos(response!)).searchPhotos);
      isLoading = false;
    });
    LogService.d(searchPhotos.length.toString());
    query = null;
  } catch (e) {
    LogService.e(e.toString());
  }
}


  void _searchPhotos() {
    searchPhotos.clear();
    query = _queryController.text;
    apiSearchPhotos(query!);
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

  DetailsPhoto getPhoto(Photo photo) {
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

  DetailsPhoto getSearchPhoto(SearchPhoto searchPhoto) {
    return DetailsPhoto(
      id: searchPhoto.id,
      createdAt: searchPhoto.createdAt,
      width: searchPhoto.width,
      height: searchPhoto.height,
      description: searchPhoto.description,
      urls: searchPhoto.urls,
      user: searchPhoto.user,
    );
  }

  Future<void> _handleRefresh() async {
    apiPhotos();
    photos.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // search bar
      appBar: AppBar(
        title: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              width: 1,
              color: Colors.grey.withOpacity(0.5),
            ),
          ),
          child: TextField(
            onSubmitted: (value) {
              if(value == ''){
                apiPhotos();
              }else{
                _searchPhotos();
              }
            },
            // onChanged: (value){
            //   if(value == ''){
            //     _apiPhotos();
            //   }else{
            //     _searchPhotos();
            //   }
            // },
            textAlignVertical: TextAlignVertical.top,
            controller: _queryController,
            decoration: InputDecoration(
              hintText: "Search photos, collections, users",
              hintStyle: const TextStyle(fontWeight: FontWeight.normal),
              border: InputBorder.none,
              prefixIcon: Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: const Icon(Iconsax.search_normal),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          (  query == null)
              ?RefreshIndicator(
            onRefresh: _handleRefresh,
            child: Container(
              padding: const EdgeInsets.only(right: 5),
              child: MasonryGridView.count(
                controller: photosScrollController,
                itemCount: photos.length,
                crossAxisCount: 2,
                itemBuilder: (context, index) {
                  return _itemOfPhotos(photos[index]);
                },
              ),
            ),
          )
          : RefreshIndicator(
            onRefresh: _handleRefresh,
            child: searchPhotos.isEmpty
                ? Center(
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
                        colorFilter:
                        ColorFilter.srgbToLinearGamma(),
                        image:
                        AssetImage('assets/images/no_data.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text('Nothing to see here...')
                ],
              ),
            )
                : Container(
              padding: const EdgeInsets.only(right: 5),
              child: MasonryGridView.count(
                controller: searchPhotosScrollController,
                itemCount: searchPhotos.length,
                crossAxisCount: 2,
                itemBuilder: (context, index) {
                  return _itemOfSearchPhotos(searchPhotos[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _itemOfPhotos(Photo photo) {
    return GestureDetector(
      onTap: () {
        _callDetailsPage(getPhoto(photo));
      },
      child: Hero(
        tag: photo.id,
        child: AspectRatio(
          aspectRatio: photo.width.toDouble() / photo.height.toDouble(),
          child: Container(
            margin: const EdgeInsets.only(top: 5, left: 5),
            child: CachedNetworkImage(
              memCacheHeight: 200,
              memCacheWidth: 150,
              fit: BoxFit.cover,
              imageUrl: photo.urls.regular,
              placeholder: (context, urls) => Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              errorWidget: (context, urls, error) => const Icon(Icons.error),
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

  Widget _itemOfSearchPhotos(SearchPhoto searchPhotos) {
    return Hero(
      tag: searchPhotos.id,
      child: AspectRatio(
        aspectRatio:
        searchPhotos.width.toDouble() / searchPhotos.height.toDouble(),
        child: GestureDetector(
          onTap: () {
            _callDetailsPage(getSearchPhoto(searchPhotos));
          },
          child: Container(
            margin: const EdgeInsets.only(top: 5, left: 5),
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: searchPhotos.urls.full,
              placeholder: (context, urls) => Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              errorWidget: (context, urls, error) => const Icon(Icons.error),
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
