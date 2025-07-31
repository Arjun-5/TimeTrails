import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:time_trails/helpers/stylized_text.dart';
import 'package:time_trails/models/landmark_distance.dart';
import 'package:time_trails/widgets/custom_box.dart';

class LandmarkGrid extends StatelessWidget {
  final String apiKey;
  final List<LandmarkDistance> landmarks;

  const LandmarkGrid({
    super.key,
    required this.apiKey,
    required this.landmarks,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.7,
      ),
      itemCount: landmarks.length,
      //itemCount: 8,
      itemBuilder: (context, index) {
        final item = landmarks[index];
        final landmark = item.landmark;
        final walking = item.walkingDistance;
        final driving = item.drivingDistance;

        return Padding(
          padding: const EdgeInsets.all(20),
          child: CustomBox(
            width: 200,
            height: 100,
            cornerRadius: 20,
            topSkewFactor: 20,
            bottomSkewFactor: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: landmark.photoUrl(apiKey),

                    //imageUrl:    "https://fastly.picsum.photos/id/1029/200/200.jpg?hmac=CQyxD4azaGb2UDjepBq254UP9v1mF-_rBhYVx8Jw8rs",
                    height: 80,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 10),
                StylizedText(
                  //landmark.name,
                  "Landmark Name",
                  textAlignment: TextAlign.center,
                ),
                const SizedBox(height: 10),
                StylizedText(
                  //'Distance: ${landmark.name}',
                  "Landmark Distance",
                  textAlignment: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
