# ChromaPath: Connect Puzzle — Firebase Analytics

Android paket adı: `com.arusoft.chromapath`. Firebase proje kimliği: `arusoft-chroma-path`. Görünen ad: ChromaPath.

`google-services.json` `android/app/` altında, `GoogleService-Info.plist` `ios/Runner/` altında. İkisi de Firebase’den indirildi. Dosya silinirse oyun yine açılır ve Analytics sessizce kapanır.

Ekranlar `FirebaseAnalytics` çağırmaz. Olaylar `lib/analytics/analytics_service.dart` üzerinden gider.

## Kurulum

1. Firebase Console → proje `arusoft-chroma-path` (görünen ad: ChromaPath). Proje ve Android ile iOS uygulamaları açık.
2. Android paket adı ve iOS bundle: `com.arusoft.chromapath`.
3. `google-services.json` ve `GoogleService-Info.plist` yerinde.
4. Gradle eklentisi dosya varsa uygulanır. Dosya yokken derleme bozulmaz.

## Olaylar

| Olay | Ne zaman | Parametreler |
|---|---|---|
| `app_open` | Açılış | `device_id`, `open_count` |
| `screen_open` | Ekran | `screen` (`home`, `levels`, `play`, `settings`, `how_to_play`) |
| `play_tap` | Oyna | `level` |
| `level_start` | Seviye başladı | `level` |
| `level_end` | Tahta doldu | `level`, `result` (`clear`), `duration_sec`, `stars`, `hints_used`, `resets_used` |
| `level_quit` | Bitmeden çıkış | `level`, `duration_sec`, `from` (`back`) |
| `settings_open` | Ayarlar | `source` |
| `how_to_play_open` | Nasıl oynanır | `source` (`first_run` / `settings`) |
| `settings_change` | Dil, ses, müzik, titreşim, hareket | `setting`, `value` |

Sürükleme, kare ve ipucu gösterimi başına olay yok. Süre, yıldız, ipucu ve sıfırlama bitiş olayının parametresidir.
