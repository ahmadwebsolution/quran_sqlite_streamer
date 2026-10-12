import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/quran_viewmodel.dart';
import 'widgets/ayah_card_widget.dart';

class QuranView extends StatefulWidget {
  const QuranView({super.key});

  @override
  State<QuranView> createState() => _QuranViewState();
}

class _QuranViewState extends State<QuranView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuranViewModel>().loadSurah(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<QuranViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Surah Al-Fatiha (MVVM)'),
        centerTitle: true,
      ),
      body: Builder(
        builder: (context) {
          switch (vm.state) {
            case ViewState.loading:
            case ViewState.initial:
              return const Center(child: CircularProgressIndicator());
            case ViewState.error:
              return Center(child: Text(vm.errorMessage ?? 'Unknown error'));
            case ViewState.loaded:
              if (vm.ayahs.isEmpty) {
                return const Center(child: Text('No Ayahs found'));
              }
              return ListView.builder(
                itemCount: vm.ayahs.length,
                itemBuilder: (context, index) {
                  final ayah = vm.ayahs[index];
                  final isCurrentActive = vm.activeAyahId == ayah.id;

                  return AyahCardWidget(
                    ayah: ayah,
                    isPlaying: vm.isAyahPlaying(ayah.id),
                    isAudioLoading: isCurrentActive && vm.isLoadingAudio,
                    onPlayToggle: () => vm.togglePlayAyah(ayah),
                  );
                },
              );
          }
        },
      ),
    );
  }
}