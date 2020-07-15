//
//  PhoneticBasePrefix.swift
//  Alamofire
//
//  Created by Daniel Clelland on 15/07/20.
//

import Foundation

public enum PhoneticBasePrefix: String, CaseIterable {

    case doz, mar, bin, wan, sam, lit, sig, hid, fid, lis, sog, dir, wac, sab, wis, sib
    case rig, sol, dop, mod, fog, lid, hop, dar, dor, lor, hod, fol, rin, tog, sil, mir
    case hol, pas, lac, rov, liv, dal, sat, lib, tab, han, tic, pid, tor, bol, fos, dot
    case los, dil, `for`, pil, ram, tir, win, tad, bic, dif, roc, wid, bis, das, mid, lop
    case ril, nar, dap, mol, san, loc, nov, sit, nid, tip, sic, rop, wit, nat, pan, min
    case rit, pod, mot, tam, tol, sav, pos, nap, nop, som, fin, fon, ban, mor, wor, sip
    case ron, nor, bot, wic, soc, wat, dol, mag, pic, dav, bid, bal, tim, tas, mal, lig
    case siv, tag, pad, sal, div, dac, tan, sid, fab, tar, mon, ran, nis, wol, mis, pal
    case las, dis, map, rab, tob, rol, lat, lon, nod, nav, fig, nom, nib, pag, sop, ral
    case bil, had, doc, rid, moc, pac, rav, rip, fal, tod, til, tin, hap, mic, fan, pat
    case tac, lab, mog, sim, son, pin, lom, ric, tap, fir, has, bos, bat, poc, hac, tid
    case hav, sap, lin, dib, hos, dab, bit, bar, rac, par, lod, dos, bor, toc, hil, mac
    case tom, dig, fil, fas, mit, hob, har, mig, hin, rad, mas, hal, rag, lag, fad, top
    case mop, hab, `nil`, nos, mil, fop, fam, dat, nol, din, hat, nac, ris, fot, rib, hoc
    case nim, lar, fit, wal, rap, sar, nal, mos, lan, don, dan, lad, dov, riv, bac, pol
    case lap, tal, pit, nam, bon, ros, ton, fod, pon, sov, noc, sor, lav, mat, mip, fip
    
}

extension PhoneticBasePrefix {
    
    public init(byte: UInt8) {
        self = PhoneticBasePrefix.allCases[Int(byte)]
    }
    
    public var byte: UInt8 {
        return UInt8(PhoneticBasePrefix.allCases.firstIndex(of: self)!)
    }
    
}
