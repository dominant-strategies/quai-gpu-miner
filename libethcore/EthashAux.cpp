/*
    This file is part of kawpowminer.

    kawpowminer is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    kawpowminer is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with kawpowminer.  If not, see <http://www.gnu.org/licenses/>.
*/

#include "EthashAux.h"

#include <ethash/ethash.hpp>
#include <ethash/progpow.hpp>
#include <ethash/hash_types.hpp>

using namespace dev;
using namespace eth;

inline std::string to_hex(const ethash::hash256& h)
{
    static const auto hex_chars = "0123456789abcdef";
    std::string str;
    str.reserve(sizeof(h) * 2);
    for (auto b : h.bytes)
    {
        str.push_back(hex_chars[uint8_t(b) >> 4]);
        str.push_back(hex_chars[uint8_t(b) & 0xf]);
    }
    return str;
}

inline ethash::hash256 to_hash256(const std::string& hex)
{
    auto parse_digit = [](char d) -> int { return d <= '9' ? (d - '0') : (d - 'a' + 10); };

    ethash::hash256 hash = {};
    for (size_t i = 1; i < hex.size(); i += 2)
    {
        int h = parse_digit(hex[i - 1]);
        int l = parse_digit(hex[i]);
        hash.bytes[i / 2] = uint8_t((h << 4) | l);
    }
    return hash;
}

Result EthashAux::eval(int epoch, h256 const& _headerHash, uint64_t _nonce) noexcept
{
    auto headerHash = ethash::hash256_from_bytes(_headerHash.data());
    auto& context = ethash::get_global_epoch_context(epoch);
    auto result = ethash::hash(context, headerHash, _nonce);
    h256 mix{reinterpret_cast<byte*>(result.mix_hash.bytes), h256::ConstructFromPointer};
    h256 final{reinterpret_cast<byte*>(result.final_hash.bytes), h256::ConstructFromPointer};
    return {final, mix};
}

Result EthashAux::eval(int epoch, int _block_number, h256 const& _headerHash, uint64_t _nonce) noexcept
{
    auto headerHash = ethash::hash256_from_bytes(_headerHash.data());
    auto& context = ethash::get_global_epoch_context(epoch);
    auto result = progpow::hash(context, _block_number, headerHash, _nonce);
    h256 mix{reinterpret_cast<byte*>(result.mix_hash.bytes), h256::ConstructFromPointer};
    h256 final{reinterpret_cast<byte*>(result.final_hash.bytes), h256::ConstructFromPointer};
    return {final, mix};
}
