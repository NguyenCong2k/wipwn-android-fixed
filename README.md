# wipwn (Android/Termux fixed build)

Bản này là bản `wipwn` đã được **decode từ file `main.py` packed** sang Python source (`main_clean.py`) để tránh lỗi **Segmentation fault** trên Termux/Python 3.14.

> Chỉ dùng để kiểm thử bảo mật trên mạng bạn sở hữu hoặc được ủy quyền. Dùng lên mạng của người khác là trái phép.

## Yêu cầu

- Android + Termux (cài từ F-Droid)
- Root (Magisk/KernelSU/APatch)
- Các gói: `python`, `wpa-supplicant`, `pixiewps`, `iw`, `openssl`

## Cài đặt

```bash
pkg update && pkg upgrade -y
pkg install root-repo -y
pkg install git python wpa-supplicant pixiewps iw openssl tsu -y
git clone https://github.com/NguyenCong2k/wipwn-android-fixed
cd wipwn-android-fixed
chmod +x wipwn.sh
```

## Chạy

```bash
python main_clean.py --help
```

Chạy scan + Pixie Dust:

```bash
su -c "cd /data/data/com.termux/files/home/wipwn-android-fixed && python main_clean.py -i wlan0 -K"
```

Hoặc dùng script:

```bash
./wipwn.sh
```

Nếu đang ở root shell:

```bash
python main_clean.py -i wlan0 -K
```

## Vì sao có `main_clean.py`?

File `main.py` gốc được packed bằng `marshal` + `zlib` + `base64`. Bytecode này không tương thích với Python 3.14 trên Termux và gây `Segmentation fault`.

`main_clean.py` là source đã decode, chạy trực tiếp bằng Python thường, không cần `exec` bytecode.

Nếu cần decode lại từ bản gốc:

```bash
python fix_wipwn.py
```

## Kiểm tra interface

```bash
ip link show
```

Nếu không phải `wlan0`, thay bằng tên thật, ví dụ `wlan1`.

## Lỗi thường gặp

| Lỗi | Cách xử lý |
|---|---|
| `python: not found` | `pkg install python -y` |
| `Permission denied` | `chmod +x wipwn.sh` |
| `Device or resource busy (-16)` | Tắt/bật lại Wi-Fi |
| `su: not found` | Máy chưa root hoặc chưa cấp quyền root cho Termux |
| `wpa_supplicant: not found` | Cài `pkg install wpa-supplicant -y`, và chạy `./wipwn.sh` bản mới (đã set PATH cho `su`) |
| Không thấy mạng WPS | Bật Location, tắt hotspot, bật Wi-Fi |

## Ghi chú

- WPS trên router đời mới thường bị tắt hoặc đã vá.
- Pixie Dust chỉ hiệu quả với một số chipset cũ.
- Bruteforce WPS chậm và dễ bị lock.

## License

MIT, giữ nguyên license gốc.
