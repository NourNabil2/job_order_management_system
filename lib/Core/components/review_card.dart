import 'package:flutter/material.dart';
import '../Utilts/Constants.dart';

class ReviewCard extends StatelessWidget {
  const ReviewCard({
    super.key,
    required this.rating,
    required this.numOfReviews,
    this.numOfFiveStar = 0,
    this.numOfFourStar = 0,
    this.numOfThreeStar = 0,
    this.numOfTwoStar = 0,
    this.numOfOneStar = 0,
  });

  final double rating;
  final int numOfReviews;
  final int numOfFiveStar,
      numOfFourStar,
      numOfThreeStar,
      numOfTwoStar,
      numOfOneStar;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(SizeApp.defaultPadding),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.035),
        borderRadius: BorderRadius.all(Radius.circular(SizeApp.borderRadius)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    text: "$rating ",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontWeight: FontWeight.w500),
                    children: [
                      TextSpan(
                        text: "/5",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
                Text("Based on $numOfReviews Reviews"),
                SizedBox(height: SizeApp.defaultPadding),
              ],
            ),
          ),
          SizedBox(width: SizeApp.defaultPadding),
          Expanded(
            child: Column(
              children: [
                RateBar(star: 5, value: numOfFiveStar / numOfReviews),
                RateBar(star: 4, value: numOfFourStar / numOfReviews),
                RateBar(star: 3, value: numOfThreeStar / numOfReviews),
                RateBar(star: 2, value: numOfTwoStar / numOfReviews),
                RateBar(star: 1, value: numOfOneStar / numOfReviews),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RateBar extends StatelessWidget {
  const RateBar({
    super.key,
    required this.star,
    required this.value,
  });

  final int star;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: star == 1 ? 0 : SizeApp.defaultPadding / 2),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Text(
              "$star Star",
              style: Theme.of(context).textTheme.labelSmall!.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium!.color),
            ),
          ),
          SizedBox(width: SizeApp.defaultPadding / 2),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(SizeApp.borderRadius),
              ),
              child: LinearProgressIndicator(
                minHeight: 6,
                color: ColorApp.warningColor,
                backgroundColor: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .color!
                    .withOpacity(0.05),
                value: value,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
