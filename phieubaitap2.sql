-- a
CREATE OR REPLACE PROCEDURE sp_ThemNhanVien
(
MaNV VARCHAR2,
TenNV VARCHAR2,
GioiTinh VARCHAR2,
DiaChi VARCHAR2,
SoDT VARCHAR2,
Email VARCHAR2,
TenPhong VARCHAR2,
Flag NUMBER,
KQ OUT NUMBER
)
AS
BEGIN

IF GioiTinh NOT IN ('Nam','N?') THEN
KQ := 1;
RETURN;
END IF;

IF Flag = 0 THEN

INSERT INTO NhanVien
VALUES(MaNV,TenNV,GioiTinh,DiaChi,SoDT,Email,TenPhong);

ELSE

UPDATE NhanVien
SET TenNV = TenNV,
GioiTinh = GioiTinh,
DiaChi = DiaChi,
SoDT = SoDT,
Email = Email,
TenPhong = TenPhong
WHERE MaNV = MaNV;

END IF;

KQ := 0;

END;
/
-- b
CREATE OR REPLACE PROCEDURE sp_ThemMoiSP
(
MaSP VARCHAR2,
TenHang VARCHAR2,
TenSP VARCHAR2,
SoLuong NUMBER,
MauSac VARCHAR2,
GiaBan NUMBER,
DonViTinh VARCHAR2,
MoTa CLOB,
Flag NUMBER,
KQ OUT NUMBER
)
AS
v_mahang VARCHAR2(10);
BEGIN

SELECT MaHangSX INTO v_mahang
FROM HangSX
WHERE TenHang = TenHang;

IF SoLuong < 0 THEN
KQ := 2;
RETURN;
END IF;

IF Flag = 0 THEN

INSERT INTO SanPham
VALUES(MaSP,v_mahang,TenSP,SoLuong,MauSac,GiaBan,DonViTinh,MoTa);

ELSE

UPDATE SanPham
SET TenSP = TenSP,
SoLuong = SoLuong,
MauSac = MauSac,
GiaBan = GiaBan,
DonViTinh = DonViTinh,
MoTa = MoTa
WHERE MaSP = MaSP;

END IF;

KQ := 0;

EXCEPTION
WHEN NO_DATA_FOUND THEN
KQ := 1;

END;
/
-- c
CREATE OR REPLACE PROCEDURE sp_XoaNhanVien
(
MaNV VARCHAR2,
KQ OUT NUMBER
)
AS
v_count NUMBER;
BEGIN

SELECT COUNT(*) INTO v_count
FROM NhanVien
WHERE MaNV = MaNV;

IF v_count = 0 THEN
KQ := 1;
RETURN;
END IF;

DELETE FROM PNhap WHERE MaNV = MaNV;
DELETE FROM PXuat WHERE MaNV = MaNV;
DELETE FROM NhanVien WHERE MaNV = MaNV;

KQ := 0;

END;
/
-- d
CREATE OR REPLACE PROCEDURE sp_XoaSanPham
(
MaSP VARCHAR2,
KQ OUT NUMBER
)
AS
v_count NUMBER;
BEGIN

SELECT COUNT(*) INTO v_count
FROM SanPham
WHERE MaSP = MaSP;

IF v_count = 0 THEN
KQ := 1;
RETURN;
END IF;

DELETE FROM Nhap WHERE MaSP = MaSP;
DELETE FROM Xuat WHERE MaSP = MaSP;
DELETE FROM SanPham WHERE MaSP = MaSP;

KQ := 0;

END;
/
-- e
CREATE OR REPLACE PROCEDURE sp_NhapHangSX
(
MaHangSX VARCHAR2,
TenHang VARCHAR2,
DiaChi VARCHAR2,
SoDT VARCHAR2,
Email VARCHAR2,
KQ OUT NUMBER
)
AS
v_count NUMBER;
BEGIN

SELECT COUNT(*) INTO v_count
FROM HangSX
WHERE TenHang = TenHang;

IF v_count > 0 THEN
KQ := 1;
RETURN;
END IF;

INSERT INTO HangSX
VALUES(MaHangSX,TenHang,DiaChi,SoDT,Email);

KQ := 0;

END;
/
-- f 
CREATE OR REPLACE PROCEDURE sp_NhapHang
(
SoHDN VARCHAR2,
MaSP VARCHAR2,
MaNV VARCHAR2,
NgayNhap DATE,
SoLuongN NUMBER,
DonGiaN NUMBER,
KQ OUT NUMBER
)
AS
v_count NUMBER;
BEGIN

SELECT COUNT(*) INTO v_count
FROM SanPham
WHERE MaSP = MaSP;

IF v_count = 0 THEN
KQ := 1;
RETURN;
END IF;

SELECT COUNT(*) INTO v_count
FROM NhanVien
WHERE MaNV = MaNV;

IF v_count = 0 THEN
KQ := 2;
RETURN;
END IF;

SELECT COUNT(*) INTO v_count
FROM Nhap
WHERE SoHDN = SoHDN;

IF v_count > 0 THEN

UPDATE Nhap
SET MaSP = MaSP,
SoLuongN = SoLuongN,
DonGiaN = DonGiaN
WHERE SoHDN = SoHDN;

ELSE

INSERT INTO PNhap VALUES(SoHDN,NgayNhap,MaNV);
INSERT INTO Nhap VALUES(SoHDN,MaSP,SoLuongN,DonGiaN);

END IF;

KQ := 0;

END;
/
-- g
CREATE OR REPLACE PROCEDURE sp_XuatHang
(
SoHDX VARCHAR2,
MaSP VARCHAR2,
MaNV VARCHAR2,
NgayXuat DATE,
SoLuongX NUMBER,
KQ OUT NUMBER
)
AS
v_count NUMBER;
v_soluong NUMBER;
BEGIN

SELECT COUNT(*) INTO v_count
FROM SanPham
WHERE MaSP = MaSP;

IF v_count = 0 THEN
KQ := 1;
RETURN;
END IF;

SELECT COUNT(*) INTO v_count
FROM NhanVien
WHERE MaNV = MaNV;

IF v_count = 0 THEN
KQ := 2;
RETURN;
END IF;

SELECT SoLuong INTO v_soluong
FROM SanPham
WHERE MaSP = MaSP;

IF SoLuongX > v_soluong THEN
KQ := 3;
RETURN;
END IF;

SELECT COUNT(*) INTO v_count
FROM Xuat
WHERE SoHDX = SoHDX;

IF v_count > 0 THEN

UPDATE Xuat
SET MaSP = MaSP,
SoLuongX = SoLuongX
WHERE SoHDX = SoHDX;

ELSE

INSERT INTO PXuat VALUES(SoHDX,NgayXuat,MaNV);
INSERT INTO Xuat VALUES(SoHDX,MaSP,SoLuongX);

END IF;

KQ := 0;

END;
/
-- a
SET SERVEROUTPUT ON
DECLARE
kq NUMBER;
BEGIN

sp_ThemNhanVien(
'NV02',
'Nguyen Van B',
'Nam',
'Ha Noi',
'0908888888',
'b@gmail.com',
'Kinh Doanh',
0,
kq
);

DBMS_OUTPUT.PUT_LINE('Ket qua = ' || kq);

END;
/
DECLARE
kq NUMBER;
BEGIN

sp_ThemNhanVien(
'NV03',
'Nguyen Van C',
'ABC',
'Ha Noi',
'0907777777',
'c@gmail.com',
'IT',
0,
kq
);

DBMS_OUTPUT.PUT_LINE('Ket qua = ' || kq);

END;
/
SELECT * FROM NhanVien;
-- b
DECLARE
kq NUMBER;
BEGIN

sp_ThemMoiSP(
'SP02',
'Samsung',
'Galaxy S23',
50,
'Den',
18000000,
'Cai',
'Dien thoai',
0,
kq
);

DBMS_OUTPUT.PUT_LINE('Ket qua = ' || kq);

END;
/
DECLARE
kq NUMBER;
BEGIN

sp_ThemMoiSP(
'SP02',
'Samsung',
'Galaxy S23 Ultra',
60,
'Trang',
20000000,
'Cai',
'Dien thoai cao cap',
1,
kq
);

DBMS_OUTPUT.PUT_LINE('Ket qua = ' || kq);

END;
/
DECLARE
kq NUMBER;
BEGIN

sp_ThemMoiSP(
'SP03',
'Apple',
'iPhone 15',
50,
'Den',
25000000,
'Cai',
'Dien thoai',
0,
kq
);

DBMS_OUTPUT.PUT_LINE('Ket qua = ' || kq);

END;
/
DECLARE
kq NUMBER;
BEGIN

sp_ThemMoiSP(
'SP04',
'Samsung',
'Galaxy A50',
-5,
'Den',
5000000,
'Cai',
'Dien thoai',
0,
kq
);

DBMS_OUTPUT.PUT_LINE('Ket qua = ' || kq);

END;
/
SELECT * FROM SanPham;
-- c
DECLARE
kq NUMBER;
BEGIN

sp_XoaNhanVien(
'NV02',
kq
);

DBMS_OUTPUT.PUT_LINE('Ket qua = ' || kq);

END;
/
DECLARE
kq NUMBER;
BEGIN

sp_XoaNhanVien(
'NV99',
kq
);

DBMS_OUTPUT.PUT_LINE('Ket qua = ' || kq);

END;
/
SELECT * FROM NhanVien;
SELECT * FROM NhanVien WHERE MaNV='NV02';
-- d
DECLARE
kq NUMBER;
BEGIN

sp_XoaSanPham(
'SP02',
kq
);

DBMS_OUTPUT.PUT_LINE('Ket qua = ' || kq);

END;
/
DECLARE
kq NUMBER;
BEGIN

sp_XoaSanPham(
'SP99',
kq
);

DBMS_OUTPUT.PUT_LINE('Ket qua = ' || kq);

END;
/
SELECT * FROM SanPham;
-- e
DECLARE
kq NUMBER;
BEGIN

sp_NhapHangSX(
'HSX02',
'Apple',
'USA',
'0907777777',
'apple@gmail.com',
kq
);

DBMS_OUTPUT.PUT_LINE('Ket qua = ' || kq);

END;
/
DECLARE
kq NUMBER;
BEGIN

sp_NhapHangSX(
'HSX03',
'Apple',
'USA',
'0907777777',
'apple@gmail.com',
kq
);

DBMS_OUTPUT.PUT_LINE('Ket qua = ' || kq);

END;
/
SELECT * FROM HangSX;
-- f
DECLARE
kq NUMBER;
BEGIN

sp_NhapHang(
'HDN02',
'SP01',
'NV01',
SYSDATE,
10,
50000,
kq
);

DBMS_OUTPUT.PUT_LINE('Ket qua = ' || kq);

END;
/
DECLARE
kq NUMBER;
BEGIN

sp_NhapHang(
'HDN03',
'SP99',
'NV01',
SYSDATE,
10,
50000,
kq
);

DBMS_OUTPUT.PUT_LINE('Ket qua = ' || kq);

END;
/
DECLARE
kq NUMBER;
BEGIN

sp_NhapHang(
'HDN04',
'SP01',
'NV99',
SYSDATE,
10,
50000,
kq
);

DBMS_OUTPUT.PUT_LINE('Ket qua = ' || kq);

END;
/
SELECT * FROM PNhap;

SELECT * FROM Nhap;

-- g
DECLARE
kq NUMBER;
BEGIN

sp_XuatHang(
'HDX01',
'SP01',
'NV01',
SYSDATE,
5,
kq
);

DBMS_OUTPUT.PUT_LINE('Ket qua = ' || kq);

END;
/

DECLARE
kq NUMBER;
BEGIN

sp_XuatHang(
'HDX02',
'SP99',
'NV01',
SYSDATE,
5,
kq
);

DBMS_OUTPUT.PUT_LINE('Ket qua = ' || kq);

END;
/
DECLARE
kq NUMBER;
BEGIN

sp_XuatHang(
'HDX03',
'SP01',
'NV99',
SYSDATE,
5,
kq
);

DBMS_OUTPUT.PUT_LINE('Ket qua = ' || kq);

END;
/
DECLARE
kq NUMBER;
BEGIN

sp_XuatHang(
'HDX04',
'SP01',
'NV01',
SYSDATE,
10000,
kq
);

DBMS_OUTPUT.PUT_LINE('Ket qua = ' || kq);

END;
/
SELECT * FROM PXuat;

SELECT * FROM Xuat;