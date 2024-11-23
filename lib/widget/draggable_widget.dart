import 'package:flutter/material.dart';
import 'package:uber/core/extension.dart';
import 'package:uber/widget/history.dart';
import 'package:uber/widget/place_tag.dart';
import 'package:uber/widget/text_field.dart';

class DraggableWidget extends StatefulWidget {
  final TextEditingController startController;
  final TextEditingController destinationController;
  const DraggableWidget({
    super.key,
    required this.startController,
    required this.destinationController,
  });

  @override
  State<DraggableWidget> createState() => _DraggableWidgetState();
}

class _DraggableWidgetState extends State<DraggableWidget> {
  final List<String> tagTitles = ['Home', 'Office'];
  final List<String> titles = [
    'Azerbaijan State Oil and Indus...',
    'Holberton School'
  ];
  final List<String> subtitles = [
    '183 Nizami St, Baku',
    '89 Ataturk avenue, Baku 1000'
  ];
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.47,
      expand: false,
      maxChildSize: 0.47,
      snap: true,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
          ),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        'Where are you going ?',
                        style: context.textStyle,
                      ),
                      const SizedBox(height: 20),
                      SearchField(
                        hint: 'Choose your start point',
                        textEditingController: widget.startController,
                        asset: 'assets/initial.svg',
                      ),
                      const SizedBox(height: 20),
                      SearchField(
                        hint: 'Choose your destination',
                        textEditingController: widget.destinationController,
                        asset: 'assets/pin.svg',
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 38,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return PlaceTag(
                              title: tagTitles[index],
                              selected: index == 0,
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 15),
                          itemCount: 2,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              SliverList.separated(
                itemCount: 2,
                itemBuilder: (context, index) {
                  return HistoryWidget(
                    title: titles[index],
                    subtitle: subtitles[index],
                  );
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ResultWidget extends StatefulWidget {
  const ResultWidget({super.key});

  @override
  State<ResultWidget> createState() => _ResultWidgetState();
}

class _ResultWidgetState extends State<ResultWidget> {
  final ValueNotifier<int> indexNotifier = ValueNotifier(0);
  final List<ResultModel> models = [
    ResultModel(
        name: 'Cheapest way',
        time: '53min',
        price: '\$0.50',
        type: 'Bus + Walk'),
    ResultModel(
        name: 'Fastest way',
        time: '24min',
        price: '\$3.20',
        type: 'Scooter (Bolt) + Walk'),
    ResultModel(
      name: 'Comfort',
      time: '45min',
      price: '\$6.20',
      type: 'Taxi (Bolt)',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.47,
      expand: false,
      maxChildSize: 0.47,
      snap: true,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
          ),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        'Choose your ride',
                        style: context.textStyle,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              SliverList.separated(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return ValueListenableBuilder(
                    valueListenable: indexNotifier,
                    builder: (context, value, child) => InkWell(
                      onTap: () => indexNotifier.value = index,
                      child: ResultCard(
                        name: models[index].name,
                        price: models[index].price,
                        time: models[index].time,
                        type: models[index].type,
                        selected: value == index,
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ResultCard extends StatelessWidget {
  final String name, price, time, type;
  final bool selected;
  const ResultCard({
    super.key,
    required this.name,
    required this.price,
    required this.time,
    required this.type,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: selected ? const Color(0xFFA277F7) : Colors.transparent,
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: context.textStyle.copyWith(
                  fontSize: 24,
                  color: selected ? Colors.white : Colors.black,
                ),
              ),
              Text(
                type,
                style: context.textStyle.copyWith(
                  fontSize: 17,
                  color: context.greyColor,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                time,
                style: context.textStyle.copyWith(
                  fontSize: 24,
                  color: selected ? Colors.white : Colors.black,
                ),
              ),
              Text(
                price,
                style: context.textStyle.copyWith(
                  fontSize: 17,
                  color: context.greyColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ResultModel {
  final String name;
  final String time;
  final String price;
  final String type;

  ResultModel(
      {required this.name,
      required this.time,
      required this.price,
      required this.type});
}
