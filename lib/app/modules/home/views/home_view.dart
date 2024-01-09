import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:get/get.dart';
import 'package:weather_app/app/data/models/address_model.dart';

import '../../../../config/translations/strings_enum.dart';
import '../../../../utils/constants.dart';
import '../../../components/api_error_widget.dart';
import '../../../components/custom_icon_button.dart';
import '../../../components/my_widgets_animator.dart';
import '../controllers/home_controller.dart';
import 'widgets/home_shimmer.dart';
import 'widgets/weather_card.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 26.w),
          child: GetBuilder<HomeController>(
            builder: (_) => MyWidgetsAnimator(
              apiCallStatus: controller.apiCallStatus,
              loadingWidget: () => const HomeShimmer(),
              errorWidget: () => ApiErrorWidget(
                retryAction: () => controller.getUserLocation(),
              ),
              successWidget: () => ListView(
                children: [
                  20.verticalSpace,
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Strings.helloAbby.tr,
                              style: theme.textTheme.displayMedium,
                            ),
                            8.verticalSpace,
                            Text(
                              Strings.discoverTheWeather.tr,
                              style: theme.textTheme.displayMedium,
                            ),
                          ],
                        ),
                      ),
                      20.horizontalSpace,
                      CustomIconButton(
                        onPressed: () => controller.onChangeThemePressed(),
                        icon: GetBuilder<HomeController>(
                          id: controller.themeId,
                          builder: (_) => Icon(
                            controller.isLightTheme
                                ? Icons.dark_mode_outlined
                                : Icons.light_mode_outlined,
                            color: theme.iconTheme.color,
                          ),
                        ),
                        borderColor: theme.dividerColor,
                      ),
                      8.horizontalSpace,
                      CustomIconButton(
                        onPressed: () => controller.onChangeLanguagePressed(),
                        icon: SvgPicture.asset(
                          Constants.language,
                          fit: BoxFit.none,
                          // color: theme.iconTheme.color,
                        ),
                        borderColor: theme.dividerColor,
                      ),
                    ],
                  ).animate().fade().slideX(
                        duration: 300.ms,
                        begin: -1,
                        curve: Curves.easeInSine,
                      ),
                  24.verticalSpace,
                  SizedBox(
                    height: 180.h,
                    child: CarouselSlider.builder(
                      options: CarouselOptions(
                        enableInfiniteScroll: false,
                        viewportFraction: 1.0,
                        enlargeCenterPage: true,
                        onPageChanged: controller.onCardSlided,
                      ),
                      itemCount: 3,
                      itemBuilder: (context, itemIndex, pageViewIndex) {
                        return WeatherCard(weather: controller.currentWeather);
                      },
                    ).animate().fade().slideY(
                          duration: 300.ms,
                          begin: 1,
                          curve: Curves.easeInSine,
                        ),
                  ),
                  16.verticalSpace,
                  GetBuilder<HomeController>(
                    id: controller.dotIndicatorsId,
                    builder: (_) => Center(
                      child: AnimatedSmoothIndicator(
                        activeIndex: controller.activeIndex,
                        count: 3,
                        effect: WormEffect(
                          activeDotColor: theme.primaryColor,
                          dotColor: theme.colorScheme.secondary,
                          dotWidth: 10.w,
                          dotHeight: 10.h,
                        ),
                      ),
                    ),
                  ),
                  24.verticalSpace,
                  Text(
                    Strings.aroundTheWorld.tr,
                    style: theme.textTheme.displayMedium,
                  ).animate().fade().slideX(
                        duration: 300.ms,
                        begin: -1,
                        curve: Curves.easeInSine,
                      ),
                  16.verticalSpace,
                  _buildSearchField(),
                  24.verticalSpace,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: double.infinity,
          height: 58,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: TextField(
                  controller: _textController,
                  // focusNode: textFocus(isStart),
                  // text: selectedAddress.value.displayAddress,
                  textCapitalization: TextCapitalization.words,
                  onChanged: (input) =>
                      controller.fetchSuggestionAddresses(input),
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      labelText: 'Search',
                      labelStyle: const TextStyle(color: Colors.black),
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xFF979797), width: 1.5),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xFFE0E0E0), width: 1.5),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      suffixIcon: _textController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _textController.clear();
                                controller.clearSearchAddress();
                              },
                            )
                          : null),
                ),
              ),
            ],
          ),
        ),
        _buildSearchedAddressList()
      ],
    );
  }

  Widget _buildSearchedAddressList() {
    return ListView.separated(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemBuilder: (_, int index) =>
            _searchAddressItem(controller.searchAddress[index]),
        separatorBuilder: (_, __) => const Divider(),
        itemCount: controller.searchAddress.length);
  }

  Widget _searchAddressItem(SuggestionModel model) {
    return InkWell(
      onTap: () async {
        await controller.onAddressSelected(model);
        _textController.text =
            controller.selectedAddress.value?.description ?? '';
        // hide keyboard
        FocusScope.of(Get.context!).requestFocus(FocusNode());
      },
      child: Container(
        height: 42,
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(model.name,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            Text(model.description,
                style: const TextStyle(
                    color: Color(0xFF9B9B9B),
                    fontSize: 10,
                    fontWeight: FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}
