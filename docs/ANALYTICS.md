# ChromaPath: Connect Puzzle — Firebase Analytics

Android paket adı: `com.arusoft.chromapath`. Firebase proje kimliği: `arusoft-chroma-path`.

`google-services.json` yokken oyun açılır. Analytics sessizce kapalı kalır. Sahte dosya yazılmaz.

Ekranlar `FirebaseAnalytics` çağırmaz. Olaylar `lib/analytics/analytics_service.dart` üzerinden gider.

## Kurulum

1. Firebase Console → proje `arusoft-chroma-path` (görünen ad: ChromaPath: Connect Puzzle).
2. Android uygulamasını `com.arusoft.chromapath` paket adıyla ekle.
3. İndirilen `google-services.json` dosyasını `android/app/` altına koy.
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
