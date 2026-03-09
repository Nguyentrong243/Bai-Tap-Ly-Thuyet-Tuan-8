CREATE TABLE HangSX (
MaHangSX VARCHAR2(10) CONSTRAINT pk_hangsx PRIMARY KEY,
TenHang VARCHAR2(30) NOT NULL,
DiaChi VARCHAR2(50),
SoDT VARCHAR2(15),
Email VARCHAR2(50)
);
CREATE TABLE SanPham (
MaSP VARCHAR2(10) CONSTRAINT pk_sanpham PRIMARY KEY,
MaHangSX VARCHAR2(10) REFERENCES HangSX(MaHangSX),
TenSP VARCHAR2(50) NOT NULL,
SoLuong NUMBER(10),
MauSac VARCHAR2(20),
GiaBan NUMBER(15,2),
DonViTinh VARCHAR2(15),
MoTa CLOB
);
CREATE TABLE NhanVien (
MaNV VARCHAR2(10) CONSTRAINT pk_nhanvien PRIMARY KEY,
TenNV VARCHAR2(50) NOT NULL,
GioiTinh VARCHAR2(10),
DiaChi VARCHAR2(100),
SoDT VARCHAR2(15),
Email VARCHAR2(50),
TenPhong VARCHAR2(30)
);
CREATE TABLE PNhap (
SoHDN VARCHAR2(10) CONSTRAINT pk_pnhap PRIMARY KEY,
NgayNhap DATE,
MaNV VARCHAR2(10) REFERENCES NhanVien(MaNV)
);
CREATE TABLE Nhap (
SoHDN VARCHAR2(10) REFERENCES PNhap(SoHDN),
MaSP VARCHAR2(10) REFERENCES SanPham(MaSP),
SoLuongN NUMBER(10),
DonGiaN NUMBER(15,2),
CONSTRAINT pk_nhap PRIMARY KEY (SoHDN, MaSP)
);
CREATE TABLE PXuat (
SoHDX VARCHAR2(10) CONSTRAINT pk_pxuat PRIMARY KEY,
NgayXuat DATE,
MaNV VARCHAR2(10) REFERENCES NhanVien(MaNV)
);
CREATE TABLE Xuat (
SoHDX VARCHAR2(10) REFERENCES PXuat(SoHDX),
MaSP VARCHAR2(10) REFERENCES SanPham(MaSP),
SoLuongX NUMBER(10),
CONSTRAINT pk_xuat PRIMARY KEY (SoHDX, MaSP)
);
-- a
CREATE OR REPLACE PROCEDURE sp_NhapHangSX
(
    p_MaHangSX VARCHAR2,
    p_TenHang  VARCHAR2,
    p_DiaChi   VARCHAR2,
    p_SoDT     VARCHAR2,
    p_Email    VARCHAR2
)
AS
    v_ma VARCHAR2(10);
BEGIN

    SELECT MaHangSX
    INTO v_ma
    FROM HangSX
    WHERE TenHang = p_TenHang;

    DBMS_OUTPUT.PUT_LINE('Ten hang da ton tai');

EXCEPTION
    WHEN NO_DATA_FOUND THEN

        INSERT INTO HangSX
        VALUES (p_MaHangSX, p_TenHang, p_DiaChi, p_SoDT, p_Email);

        COMMIT;

        DBMS_OUTPUT.PUT_LINE('Them hang thanh cong');

END;
/
SET SERVEROUTPUT ON;
BEGIN
    sp_NhapHangSX(
        'HSX01',
        'Samsung',
        'Korea',
        '0901234567',
        'samsung@gmail.com'
    );
END;
SELECT * FROM HangSX;
-- b
CREATE OR REPLACE PROCEDURE sp_NhapSP
(
    p_MaSP VARCHAR2,
    p_TenHang VARCHAR2,
    p_TenSP VARCHAR2,
    p_SoLuong NUMBER,
    p_MauSac VARCHAR2,
    p_GiaBan NUMBER,
    p_DonViTinh VARCHAR2,
    p_MoTa CLOB
)
AS
    v_mahang VARCHAR2(10);
    v_masp VARCHAR2(10);
BEGIN

    SELECT MaHangSX
    INTO v_mahang
    FROM HangSX
    WHERE TenHang = p_TenHang;

    BEGIN
        SELECT MaSP
        INTO v_masp
        FROM SanPham
        WHERE MaSP = p_MaSP;

        UPDATE SanPham
        SET TenSP = p_TenSP,
            SoLuong = p_SoLuong,
            MauSac = p_MauSac,
            GiaBan = p_GiaBan,
            DonViTinh = p_DonViTinh,
            MoTa = p_MoTa
        WHERE MaSP = p_MaSP;

        DBMS_OUTPUT.PUT_LINE('Cap nhat san pham');

    EXCEPTION
        WHEN NO_DATA_FOUND THEN

            INSERT INTO SanPham
            VALUES(p_MaSP, v_mahang, p_TenSP, p_SoLuong, p_MauSac, p_GiaBan, p_DonViTinh, p_MoTa);

            DBMS_OUTPUT.PUT_LINE('Them san pham moi');
    END;

    COMMIT;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Ten hang khong ton tai');

END;
SET SERVEROUTPUT ON;

BEGIN
sp_NhapSP(
'SP01',
'Samsung',
'Galaxy S24',
100,
'Den',
20000000,
'Cai',
'Dien thoai'
);
END;
-- c
CREATE OR REPLACE PROCEDURE sp_XoaSP (
    p_MaSP IN VARCHAR2
)
AS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM SanPham
    WHERE MaSP = p_MaSP;

    IF v_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('MaSP khong ton tai');
    ELSE
        DELETE FROM SanPham
        WHERE MaSP = p_MaSP;

        DBMS_OUTPUT.PUT_LINE('Xoa san pham thanh cong');
    END IF;

END;
/
SET SERVEROUTPUT ON;

BEGIN
    sp_XoaSP('SP01');
END;
/
-- d
CREATE OR REPLACE PROCEDURE sp_SuaSP (
    p_MaSP IN VARCHAR2,
    p_TenSP IN VARCHAR2,
    p_SoLuong IN NUMBER,
    p_MauSac IN VARCHAR2,
    p_GiaBan IN NUMBER,
    p_DonViTinh IN VARCHAR2,
    p_MoTa IN VARCHAR2
)
AS
    v_sp NUMBER;
BEGIN

    SELECT COUNT(*) INTO v_sp
    FROM SanPham
    WHERE MaSP = p_MaSP;

    IF v_sp = 0 THEN
        DBMS_OUTPUT.PUT_LINE('MaSP khong ton tai');
    ELSE
        UPDATE SanPham
        SET TenSP = p_TenSP,
            SoLuong = p_SoLuong,
            MauSac = p_MauSac,
            GiaBan = p_GiaBan,
            DonViTinh = p_DonViTinh,
            MoTa = p_MoTa
        WHERE MaSP = p_MaSP;

        DBMS_OUTPUT.PUT_LINE('Cap nhat san pham thanh cong');
    END IF;

END;
/
SET SERVEROUTPUT ON;

BEGIN
    sp_SuaSP('SP01','Laptop Dell',10,'Den',20000000,'Chiec','Laptop van phong');
END;
/
-- e
CREATE OR REPLACE PROCEDURE sp_NhapHang
(
    p_SoHDN    IN VARCHAR2,
    p_MaSP     IN VARCHAR2,
    p_MaNV     IN VARCHAR2,
    p_NgayNhap IN DATE,
    p_SoLuongN IN NUMBER,
    p_DonGiaN  IN NUMBER
)
AS
    v_sp NUMBER;
    v_nv NUMBER;
    v_hd NUMBER;
BEGIN

    SELECT COUNT(*) INTO v_sp
    FROM SanPham
    WHERE MaSP = p_MaSP;

    IF v_sp = 0 THEN
        DBMS_OUTPUT.PUT_LINE('MaSP khong ton tai');
        RETURN;
    END IF;


    SELECT COUNT(*) INTO v_nv
    FROM NhanVien
    WHERE MaNV = p_MaNV;

    IF v_nv = 0 THEN
        DBMS_OUTPUT.PUT_LINE('MaNV khong ton tai');
        RETURN;
    END IF;


    SELECT COUNT(*) INTO v_hd
    FROM PNhap
    WHERE SoHDN = p_SoHDN;


    IF v_hd = 0 THEN

        INSERT INTO PNhap (SoHDN, NgayNhap, MaNV)
        VALUES (p_SoHDN, p_NgayNhap, p_MaNV);

        INSERT INTO Nhap (SoHDN, MaSP, SoLuongN, DonGiaN)
        VALUES (p_SoHDN, p_MaSP, p_SoLuongN, p_DonGiaN);

    ELSE

        UPDATE Nhap
        SET SoLuongN = p_SoLuongN,
            DonGiaN = p_DonGiaN
        WHERE SoHDN = p_SoHDN
        AND MaSP = p_MaSP;

    END IF;

END;
/
SET SERVEROUTPUT ON;

BEGIN
sp_NhapHang('HDN01','SP01','NV01',SYSDATE,10,500000);
END;
/
-- f
CREATE OR REPLACE PROCEDURE SP_NHAPHANG
(
p_SoHDN VARCHAR2,
p_MaSP VARCHAR2,
p_SoLuong NUMBER,
p_DonGia NUMBER
)
IS
v_count NUMBER;
BEGIN

SELECT COUNT(*) INTO v_count
FROM SanPham
WHERE MaSP = p_MaSP;

IF v_count = 0 THEN
DBMS_OUTPUT.PUT_LINE('MaSP khong ton tai');

ELSE

INSERT INTO Nhap(SoHDN,MaSP,SoLuongN,DonGiaN)
VALUES(p_SoHDN,p_MaSP,p_SoLuong,p_DonGia);

UPDATE SanPham
SET SoLuong = SoLuong + p_SoLuong
WHERE MaSP = p_MaSP;

DBMS_OUTPUT.PUT_LINE('Nhap hang thanh cong');

END IF;

END;
/
SET SERVEROUTPUT ON

BEGIN
SP_NHAPHANG('HDN01','SP01',10,50000);
END;
/
-- g
CREATE OR REPLACE PROCEDURE sp_XoaNV
(
p_MaNV VARCHAR2
)
AS
v_count NUMBER;
BEGIN

SELECT COUNT(*) INTO v_count
FROM PNhap
WHERE MaNV = p_MaNV;

IF v_count > 0 THEN
DBMS_OUTPUT.PUT_LINE('Nhan vien da lap phieu nhap');
RETURN;
END IF;

SELECT COUNT(*) INTO v_count
FROM PXuat
WHERE MaNV = p_MaNV;

IF v_count > 0 THEN
DBMS_OUTPUT.PUT_LINE('Nhan vien da lap phieu xuat');
RETURN;
END IF;

DELETE FROM NhanVien
WHERE MaNV = p_MaNV;

DBMS_OUTPUT.PUT_LINE('Xoa nhan vien thanh cong');

END;
/
-- h
CREATE OR REPLACE PROCEDURE sp_XoaSanPham
(
p_MaSP VARCHAR2
)
AS
v_count NUMBER;
BEGIN

SELECT COUNT(*) INTO v_count
FROM SanPham
WHERE MaSP = p_MaSP;

IF v_count = 0 THEN
DBMS_OUTPUT.PUT_LINE('MaSP khong ton tai');
RETURN;
END IF;

SELECT COUNT(*) INTO v_count
FROM Nhap
WHERE MaSP = p_MaSP;

IF v_count > 0 THEN
DBMS_OUTPUT.PUT_LINE('San pham da ton tai trong bang Nhap');
RETURN;
END IF;

SELECT COUNT(*) INTO v_count
FROM Xuat
WHERE MaSP = p_MaSP;

IF v_count > 0 THEN
DBMS_OUTPUT.PUT_LINE('San pham da ton tai trong bang Xuat');
RETURN;
END IF;

DELETE FROM SanPham
WHERE MaSP = p_MaSP;

DBMS_OUTPUT.PUT_LINE('Xoa san pham thanh cong');

END;
/
SET SERVEROUTPUT ON

BEGIN
sp_XoaSanPham('SP01');
END;
/