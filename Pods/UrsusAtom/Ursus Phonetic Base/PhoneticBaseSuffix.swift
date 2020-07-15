//
//  PhoneticBaseSuffix.swift
//  Alamofire
//
//  Created by Daniel Clelland on 15/07/20.
//

import Foundation

public enum PhoneticBaseSuffix: String, CaseIterable {

    case zod, nec, bud, wes, sev, per, sut, `let`, ful, pen, syt, dur, wep, ser, wyl, sun
    case ryp, syx, dyr, nup, heb, peg, lup, dep, dys, put, lug, hec, ryt, tyv, syd, nex
    case lun, mep, lut, sep, pes, del, sul, ped, tem, led, tul, met, wen, byn, hex, feb
    case pyl, dul, het, mev, rut, tyl, wyd, tep, bes, dex, sef, wyc, bur, der, nep, pur
    case rys, reb, den, nut, sub, pet, rul, syn, reg, tyd, sup, sem, wyn, rec, meg, net
    case sec, mul, nym, tev, web, sum, mut, nyx, rex, teb, fus, hep, ben, mus, wyx, sym
    case sel, ruc, dec, wex, syr, wet, dyl, myn, mes, det, bet, bel, tux, tug, myr, pel
    case syp, ter, meb, set, dut, deg, tex, sur, fel, tud, nux, rux, ren, wyt, nub, med
    case lyt, dus, neb, rum, tyn, seg, lyx, pun, res, red, fun, rev, ref, mec, ted, rus
    case bex, leb, dux, ryn, num, pyx, ryg, ryx, fep, tyr, tus, tyc, leg, nem, fer, mer
    case ten, lus, nus, syl, tec, mex, pub, rym, tuc, fyl, lep, deb, ber, mug, hut, tun
    case byl, sud, pem, dev, lur, def, bus, bep, run, mel, pex, dyt, byt, typ, lev, myl
    case wed, duc, fur, fex, nul, luc, len, ner, lex, rup, ned, lec, ryd, lyd, fen, wel
    case nyd, hus, rel, rud, nes, hes, fet, des, ret, dun, ler, nyr, seb, hul, ryl, lud
    case rem, lys, fyn, wer, ryc, sug, nys, nyl, lyn, dyn, dem, lux, fed, sed, bec, mun
    case lyr, tes, mud, nyt, byr, sen, weg, fyr, mur, tel, rep, teg, pec, nel, nev, fes
    
}

extension PhoneticBaseSuffix {
    
    public init(byte: UInt8) {
        self = PhoneticBaseSuffix.allCases[Int(byte)]
    }
    
    public var byte: UInt8 {
        return UInt8(PhoneticBaseSuffix.allCases.firstIndex(of: self)!)
    }
    
}
