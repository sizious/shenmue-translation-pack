/* CRC calculation: calculates the CRC on a VMU file to be written out */
int vmu_pkg_crc(const uint8 * buf, int size) {
	int	i, c, n;
	
	for (i=0, n=0; i<size; i++) {
		n ^= (buf[i] << 8);
		for (c=0; c<8; c++) {
			if (n & 0x8000)
				n = (n << 1) ^ 4129;
			else
				n = (n << 1);
		}
	}

	return n & 0xffff;
}

bool fix_shenmue_save(uint8 *buf, ssize_t size) {
	vmu_hdr_t *hdr;
	uint16 new_crc;

	if ((buf[0x680] != 'S') || (buf[0x681] != 'H') || (buf[0x682] != 'E')) {
		return false;
	}

	buf[0x683] = 0x45;
	buf[0x684] = 0x0E;
	buf[0x685] = 0x01;
	buf[0x689] = 0x58;
	// let's calculate the new CRC value for the fixed file
	hdr = (vmu_hdr_t *)buf;
	hdr->crc = 0;
	new_crc = vmu_pkg_crc(buf, size);
	hdr->crc = new_crc;

	return true;
}